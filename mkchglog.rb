#!/usr/bin/env ruby

rawlog = `git log --date-order --date=short --pretty=format:"%cd %cN <%cE>%n%n* %s%n%b%n" | fold -sw72`

dateauth=""
skipflag=false
commentbody=false
logdat=[]

rawlog.each_line do |line|
	line.chomp!
	if skipflag then
		skipflag = false
	elsif line =~ /^\d{4}-\d\d-\d\d / then
		commentbody = false
		if dateauth != line then
			logdat.push ""
			logdat.push line
		else
			skipflag = true
		end
		dateauth = line
	elsif commentbody then
		if line.empty? then
			# noop
		else
			line.gsub!(/^\*/, "-")
			logdat.push ("\t\t" + line)
		end
	elsif line =~ /^\*/ then
		commentbody = true
		logdat.push ("\t" + line)
	else
		logdat.push line
	end
end

logdat.shift if logdat[0].empty?
print logdat.join("\n"), "\n"
