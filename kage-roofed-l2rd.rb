#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/Kage.rb"

############################################################################

def find_roofed_l2rd(stat, glyph) # 屋根付き右はらい
	stat['leftToRightDown'] = {'horiz' => [], 'down' => []}
	for stroke, index in glyph.each_with_index
		if stroke[0..2] == [1, 0, 0] and stroke.startY == stroke.endY then
			stat['leftToRightDown']['horiz'].push([index, stroke.dup])
		elsif (stroke[0..2] == [2, 7, 0] or stroke[0..2] == [6, 7, 0]) and stroke.startY < stroke.endY then
			stat['leftToRightDown']['down'].push([index, stroke.dup])
		end
	end
end

def replace_roofed_l2rd(stat, glyph) # 屋根付き右はらい
	if not (stat['leftToRightDown']['horiz'].empty? or stat['leftToRightDown']['down'].empty?) then
		intersectThreshold = 10
		for horizCandidate in stat['leftToRightDown']['horiz']
			for downCandidate in stat['leftToRightDown']['down']
				if ((downCandidate[1].startX)..(downCandidate[1].startX + intersectThreshold * 2)).cover?(horizCandidate[1].endX) and
						((horizCandidate[1].endY - intersectThreshold)..(horizCandidate[1].endY + intersectThreshold)).cover?(downCandidate[1].startY) then
					index = downCandidate[0]
					xIndex = horizCandidate[0]
					stroke = downCandidate[1].dup
					xStroke = horizCandidate[1].dup
					STDERR.write("#{glyph.name}: 屋根付き右はらいをインデックス#{index}で検出！\n")
					stroke.startY = xStroke.endY
					stroke.startType = 27
					xStroke.endX = stroke.startX
					xStroke.endType = 2
					glyph[index] = stroke
					glyph[xIndex] = xStroke
				end
			end
		end
	end
end

############################################################################
# グリフごとにループ
while l = ARGF.gets
	l.chomp!
	glyph = nil
	begin
		glyph = Kage::Glyph.new(l)
	rescue NoMethodError
		STDERR.write("\e[33m\e[1m\e[41m#{l.split(/\t/)[0]}: 異常データ！！→#{l.split(/\t/)[1]}\n\e[0m")
		print "#{l}\n"
		next
	end
	stat = {}
	if not glyph.ref_only? then
		# 屋根付き右はらい検出
		find_roofed_l2rd(stat, glyph)
		# 屋根付き右はらいを置換え
		replace_roofed_l2rd(stat, glyph)
	end
	print "#{glyph.to_s}\n"
end
