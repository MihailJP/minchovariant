#!/usr/bin/env ruby

if ARGV.length < 1 then
	STDERR.write("Usage: #{$0} fontID\n")
	exit(1)
end

require 'sqlite3'
DBFileName = 'HZMincho.db'
if not File.exist?(DBFileName) then raise IOError, "Database '#{DBFileName}' not found" end
fontDB = SQLite3::Database.new(DBFileName)
SubFontName = fontDB.execute("SELECT fontName FROM subFont WHERE FontID = #{ARGV[0]}")[0][0]

print("mergeFonts #{SubFontName}\n")
fontDB.execute("SELECT CID, glyphName FROM cidKeys WHERE fontID = #{ARGV[0]}").each {|gID, gName|
	printf("%05d\t%s\n", gID, gName)
}
