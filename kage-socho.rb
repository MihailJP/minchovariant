#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/Kage.rb"

while l = ARGF.gets
	l.chomp!
	glyph = Kage::Glyph.new(l)
	stat = {
		'walkRadical' => {'index' => nil, 'type' => nil, 'stat' => 0, 'tmpPos' => [nil, nil]}
	}
	if not glyph.ref_only? then
		# 特定部首検出
		for stroke, index in glyph.each_with_index
			# 之繞
			if stroke[0..2] == [2, 7, 8] and stroke.strokelength < 60 and [0, 1].include?(stat['walkRadical']['stat']) then
				stat['walkRadical']['stat'] += 1
			elsif stroke[0..2] == [1, 0, 2] and stroke.strokelength < 60 and [1, 2].include?(stat['walkRadical']['stat']) then
				stat['walkRadical']['stat'] += 2
				stat['walkRadical']['tmpPos'] = stroke[5..6]
			elsif stroke[0..2] == [1, 22, 0] and [3, 4].include?(stat['walkRadical']['stat']) and stroke[3..4] == stat['walkRadical']['tmpPos'] then
				stat['walkRadical']['stat'] += 2
				stat['walkRadical']['tmpPos'] = stroke[5..6]
			elsif stroke[0..2] == [2, 0, 7] and [5, 6].include?(stat['walkRadical']['stat']) and Math.hypot(stroke[7] - stat['walkRadical']['tmpPos'][0], stroke[8] - stat['walkRadical']['tmpPos'][1]) < 12 then
				stat['walkRadical']['stat'] += 2
			elsif (stroke[0..2] == [2, 7, 0] or stroke[0..2] == [6, 7, 0]) and [7, 8].include?(stat['walkRadical']['stat']) and Math.hypot(stroke[3] - stat['walkRadical']['tmpPos'][0], stroke[4] - stat['walkRadical']['tmpPos'][1]) < 12 then
				stat['walkRadical']['index'] = index - stat['walkRadical']['stat'] + 3
				stat['walkRadical']['type'] = stat['walkRadical']['stat'] - 6
				stat['walkRadical']['stat'] = 0
				stat['walkRadical']['tmpPos'] = [nil, nil]
				STDERR.write("#{glyph.name}: #{stat['walkRadical']['type']}点之繞をインデックス#{stat['walkRadical']['index']}で検出！\n")
			else
				stat['walkRadical']['stat'] = 0
				stat['walkRadical']['tmpPos'] = [nil, nil]
			end
		end
		# 特定部首を宋朝体字形に置換え
		if not stat['walkRadical']['index'].nil? then # 之繞
			index = stat['walkRadical']['index'] + stat['walkRadical']['type']
			baseWidth = glyph[index].to_a[5] - glyph[index].to_a[3]
			
			stroke = glyph[index].to_a
			stroke[3] += baseWidth * 2 / 9
			stroke[4] += 4
			stroke[5] += baseWidth * 2 / 9
			glyph[index] = stroke
			
			stroke = glyph[index + 1].to_a
			stroke[0] = 2
			stroke[2] = 7
			stroke.push(stroke[5], stroke[6])
			stroke[3] += baseWidth * 2 / 9
			stroke[5] = (stroke[3] * 2 + stroke[7]) / 3
			stroke[6] = (stroke[4] + stroke[8]) / 2
			stroke[7] -= baseWidth / 9
			stroke[8] -= 1
			glyph[index + 1] = stroke
			
			stroke = glyph[index + 2].to_a
			stroke[4] = (stroke[4] - stroke[8]) / 2 + stroke[8]
			stroke[6] = (stroke[6] - stroke[8]) / 2 + stroke[8]
			stroke[7] -= baseWidth * 2 / 9
			glyph[index + 2] = stroke
			
			stroke = glyph[index + 3].to_a
			if stroke[0] == 6 then
				stroke[0] = 2
				stroke[7..10] = stroke[9..10]
			end
			stroke[3] -= baseWidth * 2 / 9
			if stroke[6] > stroke[8] then
				stroke[6], stroke[8] = stroke[8], stroke[6]
			end
			glyph[index + 3] = stroke
			
			if stat['walkRadical']['type'] == 1 then
				baseY = glyph[index - 1].to_a[8]
				stroke0 = glyph[index + 0].to_a
				stroke1 = glyph[index + 1].to_a
				spanY = (stroke1[4] - baseY) / 2
				stroke0[4] -= spanY / 2
				stroke0[6] -= spanY / 2
				stroke1[4] -= spanY / 2
				downHeight = stroke1[8] - stroke1[4] - 1
				stroke1[6] = (stroke1[6] - stroke1[4]) * 2 / 5 + stroke1[4]
				stroke1[8] = (stroke1[8] - stroke1[4]) * 2 / 5 + stroke1[4]
				stroke2 = [2, 7, 8,
				           stroke1[7], stroke1[8] - 1,
				           stroke1[3] + 1, stroke1[4] + downHeight * 55 / 100,
				           stroke1[3], stroke1[4] + downHeight * 7 / 10 + 1]
				stroke3 = [2, 32, 7,
				           stroke1[3], stroke1[4] + downHeight * 7 / 10 - 1,
				           stroke1[3] - 1, stroke1[4] + downHeight * 9 / 10,
				           stroke1[7], stroke1[4] + downHeight]
				glyph[index] = stroke0
				glyph[index + 1] = stroke1
				glyph.insert(index + 2, stroke2, stroke3)
			end
		end
	end
	print "#{glyph.to_s}\n"
end
