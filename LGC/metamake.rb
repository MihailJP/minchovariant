#!/usr/bin/env ruby

require 'sqlite3'
DBFileName = '../HZMincho.db'
if not File.exist?(DBFileName) then raise IOError, "Database '#{DBFileName}' not found" end
fontDB = SQLite3::Database.new(DBFileName)

TargetWeight=[1, 3, 5, 7, 9]
FileNameHeader="lgc"
Targets={}
fontDB.execute("SELECT fontTag, srcPrefix, srcSuffix, tSuffix, rotated FROM lgcFont") {|subFont|
	Targets[subFont[0]] = {
		"srcPrefix" => subFont[1],
		"srcSuffix" => subFont[2],
		"tSuffix"   => subFont[3],
		"rotated"   => subFont[4]
	}
}
Interpol={1 => -0.5, 3 => -0.3, 5 => 0, 7 => 0.4, 9 => 0.8}

# TARGETS
print "TARGETS= "
for target in Targets
	print "\\\n\t"
	for weight in TargetWeight
		print "#{FileNameHeader}#{weight.to_s}#{target[1]["tSuffix"]}.otf "
	end
end
print "\n"

# SRCDIRS
for target in Targets
	prefix=target[1]["srcPrefix"]
	suffix=target[1]["srcSuffix"]
	if suffix == ".sfdir" then suffix += "/font.props" end
	print "#{target[0]}=#{prefix}Medium#{suffix} #{prefix}Bold#{suffix}\n"
end

# .DELETE_ON_ERROR
print "\n.DELETE_ON_ERROR: $(TARGETS)"
for target in Targets
	suffix=target[1]["srcSuffix"]
	if suffix == ".sfd" then
		print " $(#{target[0]})"
	end
end
print "\n"

# all
print <<FINIS

.PHONY: all clean
all: $(TARGETS)

FINIS

# Makefile
print <<FINIS
Makefile: metamake.rb ../HZMincho.sql
	./metamake.rb > $@

FINIS

# third- and quarter-width
print <<FINIS
Third-Medium.sfd: Fixed-Medium.sfdir/font.props
	fontforge ./narrow.py Fixed-Medium.sfdir $@ 0.666667
Third-Bold.sfd: Fixed-Bold.sfdir/font.props
	fontforge ./narrow.py Fixed-Bold.sfdir $@ 0.666667
Quarter-Medium.sfd: Fixed-Medium.sfdir/font.props
	fontforge ./narrow.py Fixed-Medium.sfdir $@ 0.5
Quarter-Bold.sfd: Fixed-Bold.sfdir/font.props
	fontforge ./narrow.py Fixed-Bold.sfdir $@ 0.5

FINIS

# pre-rotated
# SRCDIRS
for target in Targets
	if target[1]["rotated"] then
		prefix=target[1]["srcPrefix"]
		suffix=target[1]["srcSuffix"]
		depSuffix = suffix + (suffix == ".sfdir" ? "/font.props" : "")
		tPrefix=Targets[target[1]["rotated"]]["srcPrefix"]
		tSuffix=Targets[target[1]["rotated"]]["srcSuffix"]
print <<FINIS
#{tPrefix}Medium#{tSuffix}: #{prefix}Medium#{depSuffix}
	fontforge ./rotate.py #{prefix}Medium#{suffix} $@
#{tPrefix}Bold#{tSuffix}: #{prefix}Bold#{depSuffix}
	fontforge ./rotate.py #{prefix}Bold#{suffix} $@
FINIS
	end
end
print "\n"

# targets
for target in Targets
	prefix=target[1]["srcPrefix"]
	suffix=target[1]["srcSuffix"]
	for weight in TargetWeight
		print "#{FileNameHeader}#{weight.to_s}#{target[1]["tSuffix"]}.otf: $(#{target[0]})\n"
		print "\tfontforge ./interpol.py $@ #{Interpol[weight]} #{prefix}Medium#{suffix} #{prefix}Bold#{suffix}\n"
	end
end

# clean
print <<FINIS

clean:
	-rm -f $(TARGETS) *.sfd
FINIS
