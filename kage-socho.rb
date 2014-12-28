#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/Kage.rb"

while l = ARGF.gets
	l.chomp!
	glyph = Kage::Glyph.new(l)
	stat = {
		'walkRadical' => {'index' => nil, 'type' => nil, 'stat' => 0, 'tmpPos' => [nil, nil]},
		'specialL2RD' => {'index' => nil}
	}
	if not glyph.ref_only? then
		# 特定部首検出
		for stroke, index in glyph.each_with_index
			# 之繞
			if stroke[0..2] == [2, 7, 8] and stroke.strokelength < 60 and [0, 1].include?(stat['walkRadical']['stat']) then
				stat['walkRadical']['stat'] += 1
			elsif stroke[0..2] == [1, 0, 2] and stroke.strokelength < 60 and [1, 2].include?(stat['walkRadical']['stat']) then
				stat['walkRadical']['stat'] += 2
				stat['walkRadical']['tmpPos'] = stroke.endPoint
			elsif stroke[0..2] == [1, 22, 0] and [3, 4].include?(stat['walkRadical']['stat']) and stroke.startPoint == stat['walkRadical']['tmpPos'] then
				stat['walkRadical']['stat'] += 2
				stat['walkRadical']['tmpPos'] = stroke.endPoint
			elsif stroke[0..2] == [2, 0, 7] and [5, 6].include?(stat['walkRadical']['stat']) and Kage.dist(stroke.endPoint, stat['walkRadical']['tmpPos']) < 12 then
				stat['walkRadical']['stat'] += 2
			elsif (stroke[0..2] == [2, 7, 0] or stroke[0..2] == [6, 7, 0]) and [7, 8].include?(stat['walkRadical']['stat']) and Kage.dist(stroke.startPoint, stat['walkRadical']['tmpPos']) < 12 then
				stat['walkRadical']['index'] = index - stat['walkRadical']['stat'] + 3
				stat['walkRadical']['type'] = stat['walkRadical']['stat'] - 6
				stat['walkRadical']['stat'] = 0
				stat['walkRadical']['tmpPos'] = [nil, nil]
				STDERR.write("#{glyph.name}: #{stat['walkRadical']['type']}点之繞をインデックス#{stat['walkRadical']['index']}で検出！\n")
			else
				stat['walkRadical']['stat'] = 0
				stat['walkRadical']['tmpPos'] = [nil, nil]
			end
			if stroke[0..2] == [6, 7, 0] and stroke.control2Y >= stroke.endY and stat['walkRadical']['index'].nil? then # 特殊型右はらい
				stat['specialL2RD']['index'] = index
				STDERR.write("#{glyph.name}: 特殊型右はらいをインデックス#{index}で検出！\n")
			end
		end
		# 特定部首を宋朝体字形に置換え
		if not stat['walkRadical']['index'].nil? then # 之繞
			index = stat['walkRadical']['index'] + stat['walkRadical']['type']
			baseWidth = glyph[index].endX - glyph[index].startX
			
			stroke = glyph[index]
			stroke.startX += baseWidth * 2 / 9
			stroke.startY += 4
			stroke.endX += baseWidth * 2 / 9
			glyph[index] = stroke
			
			stroke = glyph[index + 1]
			stroke.strokeType = 2
			stroke.endType = 7
			stroke.startX += baseWidth * 2 / 9
			stroke.control1X = (stroke.startX * 2 + stroke.endX) / 3
			stroke.control1Y = (stroke.endY + stroke.endY) / 2
			stroke.endX -= baseWidth / 9
			stroke.endY -= 1
			glyph[index + 1] = stroke
			
			stroke = glyph[index + 2]
			stroke.startY = (stroke.startY - stroke.endY) / 2 + stroke.endY
			stroke.control1Y = (stroke.control1Y - stroke.endY) / 2 + stroke.endY
			stroke.endX -= baseWidth * 2 / 9
			glyph[index + 2] = stroke
			
			stroke = glyph[index + 3]
			if stroke.strokeType == 6 then
				stroke.endY = stroke.control2Y
				stroke.controlPoint2 = stroke.controlPoint1
				stroke.strokeType = 2
			end
			stroke.startX -= baseWidth * 2 / 9
			if stroke.control1Y > stroke.endY then
				stroke.control1Y, stroke.endY = stroke.endY, stroke.control1Y
			end
			glyph[index + 3] = stroke
			
			if stat['walkRadical']['type'] == 1 then
				baseY = glyph[index - 1].endY
				stroke0 = glyph[index + 0]
				stroke1 = glyph[index + 1]
				spanY = (stroke1.startY - baseY) / 2
				stroke0.startY -= spanY / 2
				stroke0.endY -= spanY / 2
				stroke1.startY -= spanY / 2
				downHeight = stroke1.endY - stroke1.startY - 1
				stroke1.control1Y = (stroke1.control1Y - stroke1.startY) * 2 / 5 + stroke1.startY
				stroke1.endY = (stroke1.endY - stroke1.startY) * 2 / 5 + stroke1.startY
				stroke2 = [2, 7, 8,
				           stroke1.endX, stroke1.endY - 1,
				           stroke1.startX + 1, stroke1.startY + downHeight * 55 / 100,
				           stroke1.startX, stroke1.startY + downHeight * 7 / 10 + 1]
				stroke3 = [2, 32, 7,
				           stroke1.startX, stroke1.startY + downHeight * 7 / 10 - 1,
				           stroke1.startX - 1, stroke1.startY + downHeight * 9 / 10,
				           stroke1.endX, stroke1.startY + downHeight]
				glyph[index] = stroke0
				glyph[index + 1] = stroke1
				glyph.insert(index + 2, stroke2, stroke3)
			end
		end
		if not stat['specialL2RD']['index'].nil? then # 特殊型右はらい
			index = stat['specialL2RD']['index']
			stroke = glyph[index]
			stroke.endY = stroke.control2Y
			stroke.controlPoint2 = stroke.controlPoint1
			stroke.strokeType = 2
			glyph[index] = stroke
			for xStroke, xIndex in glyph.each_with_index
				if xIndex != index then
					xStroke = glyph[xIndex]
					if (not xStroke.ref?) and ((stroke.control1X)..(stroke.endX)).cover?(xStroke.endX) and ((stroke.control1Y)..(stroke.endY)).cover?(xStroke.endY) then
						slope = (stroke.endY - stroke.control1Y).to_f / (stroke.endX - stroke.control1X).to_f
						yIntercept = stroke.control1Y.to_f - slope * stroke.control1X.to_f
						xStroke.endY = (xStroke.endX * slope + yIntercept - 3).round
						glyph[xIndex] = xStroke
					end
				end
			end
			if index > 0 then
				xStroke = glyph[index - 1]
				if xStroke[0..2] == [2, 0, 7] and Kage.dist(xStroke.endPoint, stroke.startPoint) < 12 then
					xStroke.startY = (xStroke.startY - xStroke.endY) / 2 + xStroke.endY
					xStroke.control1Y = (xStroke.control1Y - xStroke.endY) / 2 + xStroke.endY
					glyph[index - 1] = xStroke
				end
			end
		end
	end
	print "#{glyph.to_s}\n"
end
