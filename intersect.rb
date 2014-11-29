#!/usr/bin/env ruby

SCRDIR = File.expand_path(File.dirname(__FILE__))
SCRIPTFILE = "#{SCRDIR}/intersect-#{$$}.pe"
$scriptMode = 0
$lastGlyph = "when loading"
$finishedList = []
$failedList = []

class TimeoutError < IOError
end

def checkGlyph(pipe)
	$lastGlyph = pipe.gets.chomp
	STDOUT.write("\r                          \r#{$lastGlyph}")
	STDOUT.flush
	nil
end

def outputScript(mode)
	workaroundList = ($failedList.map {|glyphName| "GlyphInfo(\"Name\") == \"#{glyphName}\""}).join(" || ")
	open(SCRIPTFILE, "w") {|file|
	file.write <<FINIS
#!/usr/bin/env fontforge

if ( $argc < 3 )
	PostNotice(StrJoin(["Usage:", $0, "infont outfont"], " "))
	Quit(1)
endif

Open($1)
Print("loaded")
SelectWorthOutputting()
#{($finishedList.map {|glyphName| "SelectFewer(\"#{glyphName}\")"}).join("\n")}
foreach
	Print(GlyphInfo("Name"))
	if ( #{workaroundList.empty? ? "0" : workaroundList} )
		Scale(0.25)
		RoundToInt()
		Scale(4.0)
	else
		RoundToInt()
	endif
	FindIntersections()
endloop
Print("finished")
#{mode == 0 ? "" : "Save($2)"}
FINIS
	}
	File.chmod(0755, SCRIPTFILE)
end

begin
	for mode in [0, 1]
		begin
			outputScript(mode)
			IO.popen([SCRIPTFILE, ARGV[0], ARGV[1], {:pgroup => 0}]) do |pipe|
				checkGlyph(pipe)
				loop do
					if IO.select([pipe], [], [], 10).nil? then
						Process.kill("INT", pipe.pid)
						raise TimeoutError
					else
						checkGlyph(pipe)
						break if $lastGlyph == "finished"
						$finishedList.push($lastGlyph) if mode == 0
					end
				end
			end
		rescue TimeoutError
			STDERR.puts("Child process does not respond (#{$lastGlyph})")
			$finishedList.pop
			$failedList.push($lastGlyph)
			retry
		end
		print "\n"
		$finishedList.clear
	end

	print "\nFinished\n"
ensure
	File.unlink(SCRIPTFILE)
end
