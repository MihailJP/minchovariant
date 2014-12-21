#!/usr/bin/env ruby

if ARGV.length < 2 then
	STDERR.write("Usage: #{$0} infile outfile\n")
	exit(1)
end

WatchdogFileName = "_WATCHDOG_" + File.basename(ARGV[1], File.extname(ARGV[1]))

SigLst = Signal.list
class TimeoutError < IOError
end

class WatchdogTimerReader
	def initialize(filename)
		@fileName = filename
	end
	def remove()
		begin
			File.unlink(@fileName)
		rescue Errno::ENOENT
		end
		nil
	end
	def check()
		begin
			return Time.now - File.stat(@fileName).mtime
		rescue Errno::ENOENT
			return nil
		end
	end
	attr_reader :fileName
end

while true
	begin
		watchdog = WatchdogTimerReader.new(WatchdogFileName)
		watchdog.remove
		pid = spawn("#{File.dirname(__FILE__)}/merge-contours.py", ARGV[0], ARGV[1], {:pgroup => 0})
		loop do
			secsFromLastUpdate = watchdog.check
			if !(secsFromLastUpdate.nil?) and (secsFromLastUpdate >= 10) then
				Process.kill("-TERM", pid)
				Process.waitpid(pid)
				raise TimeoutError
			end
			unless Process.waitpid(pid, Process::WNOHANG).nil? then
				break
			end
			sleep(1)
		end
	rescue TimeoutError
		STDERR.puts("Child process does not respond\n")
		retry
	rescue SignalException => e
		STDERR.puts("#{e.message}\n")
		Process.kill("-TERM", pid)
		Process.waitpid(pid)
		exit(e.signo | 0x80)
	end
	stat = $?.signaled? ? ($?.termsig | 0x80) : $?.exitstatus
	STDERR.write("Child process ended with exit status code #{stat}\n")
	case stat
	when 0, 1, (SigLst["INT"]|0x80), (SigLst["QUIT"]|0x80), (SigLst["KILL"]|0x80), (SigLst["TERM"]|0x80)
		exit(stat)
	end
end
