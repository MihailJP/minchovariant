#!/usr/bin/env ruby

TargetWeight=[1, 3, 5, 7, 9]
FileNameHeader="lgc"
Targets={
    "SRCDIRS"      => {"srcPrefix" => "",
                       "srcSuffix" => ".sfdir",
                       "tSuffix"   => ""},
    "FIXEDDIRS"    => {"srcPrefix" => "Fixed-",
                       "srcSuffix" => ".sfdir",
                       "tSuffix"   => "f"},
    "THIRDWIDTH"   => {"srcPrefix" => "Third-",
                       "srcSuffix" => ".sfd",
                       "tSuffix"   => "t"},
    "QUARTERWIDTH" => {"srcPrefix" => "Quarter-",
                       "srcSuffix" => ".sfd",
                       "tSuffix"   => "q"},
    "WIDEDIRS"     => {"srcPrefix" => "Wide-",
                       "srcSuffix" => ".sfdir",
                       "tSuffix"   => "w"},
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

# all
print <<FINIS

.PHONY: all clean
all: $(TARGETS)

FINIS

# Makefile
print <<FINIS
Makefile: metamake.rb
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
	-rm $(TARGETS) Third-Medium.sfd Third-Bold.sfd Quarter-Medium.sfd Quarter-Bold.sfd
FINIS
