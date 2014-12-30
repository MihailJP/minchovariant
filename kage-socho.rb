#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/Kage.rb"

preInputGlyph = {
	'u5196-03' => Kage::Glyph.new("u5196-03\t2:7:8:31:16:32:53:16:65$1:0:2:32:31:176:31$2:22:7:176:31:170:43:156:63")
}
convertGlyphList = {
	'u4eca'    => ['u4eca-var-002',     0,   0, 200, 200],
	'u4eca-01' => ['u4eca-01-var-001',  0,   0, 200, 200],
	'u4eca-02' => ['u4eca-02-var-001',  0,   0, 200, 200],
	'u4ee4'    => ['u4ee4-g',           0,   0, 200, 200],
	'u4ee4-01' => ['u4ee4-g01',         0,   0, 200, 200],
	'u4ee4-02' => ['u4ee4-02-var-001',  0,   0, 200, 200],
	'u4ee4-04' => ['u4ee4-g04',         0,   0, 200, 200],
	'u4ee4-07' => ['u4ee4-g02',      -114,   0, 211, 200],
	'u4ee4-09' => ['u4ee4-g04',         0, -16, 200, 156],
	'u5b80'    => ['u5b80-t07',         0,   0, 200, 200],
	'u5b80-03' => ['u5b80-t03',         0,   0, 200, 200],
	'u706b'    => ['u706b-var-004',     0,   0, 200, 200],
	'u706b-01' => ['u706b-01-var-002',  0,   0, 200, 200],
	'u706b-02' => ['u706b-02-var-002',  0,   0, 200, 200],
	'u706b-03' => ['u706b-03-var-004',  0,   0, 200, 200],
	'u706b-04' => ['u706b-04-var-006',  0,   0, 200, 200],
	'u706b-06' => ['u706b-06-var-005',  0,   0, 200, 200],
	'u8a00'    => ['u8a00-t',           0,   0, 200, 200],
	'u8a00-02' => ['u8a00-t02',         0,   0, 200, 200],
	'u8a00-04' => ['u8a00-t04',         0,   0, 200, 200],
	'u8a01'    => ['u8a01-g',           0,   0, 200, 200],
	'u8a01-01' => ['u8a01-g01',         0,   0, 179, 200]
}

while l = ARGF.gets
	l.chomp!
	glyph = Kage::Glyph.new(l)
	stat = {
		'dereference'  => {},
		'walkRadical'  => {'index' => nil, 'type' => nil, 'stat' => 0, 'tmpPos' => [nil, nil]},
		'specialL2RD'  => {'index' => nil},
		'pointOnHoriz' => {'horiz' => [], 'point' => [], 'diagonal' => []}
	}
	if convertGlyphList.has_key?(glyph.name) then
		# 特定のグリフ置き換え
		repGlyph = convertGlyphList[glyph.name][0]
		STDERR.write("#{glyph.name}: 置き換え対照グリフ→#{repGlyph}\n")
		glyph.replace_with("99:0:0:#{convertGlyphList[glyph.name][1..4].join(":")}:#{repGlyph}")
	elsif not glyph.ref_only? then
		# 特定の参照を解体
		begin
			tmpGlyph = glyph.to_a
			for stroke, index in glyph.each_with_index.reverse_each
				if stroke.ref? and preInputGlyph.include?(stroke.link_to) then
					refDat = preInputGlyph[stroke.link_to].dup
					tmpRefDat = refDat.to_a
					for tmpStrokeRaw, k in tmpRefDat.each_with_index
						tmpStroke = tmpStrokeRaw.to_a
						for i in [4, 6, 8, 10].reject {|x| x >= tmpStroke.to_a.length}
							tmpStroke[i - 1] = tmpStroke[i - 1] * (stroke.endX - stroke.startX) / 200 + stroke.startX
							tmpStroke[i    ] = tmpStroke[i    ] * (stroke.endY - stroke.startY) / 200 + stroke.startY
						end
						tmpRefDat[k] = Kage::Stroke.new(tmpStroke)
					end
					refDat.replace_with tmpRefDat
					derefRange = (index)...(index + refDat.length)
					stat['dereference'][derefRange] = stroke.dup
					tmpGlyph[index..index] = refDat.to_a
				end
			end
			glyph.replace_with(tmpGlyph)
		end
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
			
			if stroke[0] == 1 and stroke.startY == stroke.endY then #なべぶた・ウ冠
				stat['pointOnHoriz']['horiz'].push([index, stroke.dup])
			elsif stroke[0..1] == [1, 0] and stroke.startX == stroke.endX then
				stat['pointOnHoriz']['point'].push([index, stroke.dup])
			elsif (stroke[0..2] == [2, 7, 8] or stroke[0..2] == [2, 0, 7])and stroke.startY < stroke.endY then
				stat['pointOnHoriz']['diagonal'].push([index, stroke.dup])
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
		if not (stat['pointOnHoriz']['horiz'].empty? or stat['pointOnHoriz']['point'].empty?) #なべぶた・ウ冠
			intersectThreshold = 10
			for pointCandidate, index in stat['pointOnHoriz']['point'].each_with_index
				for horizCandidate in stat['pointOnHoriz']['horiz']
					if ((horizCandidate[1].startX)..(horizCandidate[1].endX)).cover?(pointCandidate[1].endX) and
							((pointCandidate[1].startY + intersectThreshold)..(pointCandidate[1].endY - intersectThreshold)).cover?(horizCandidate[1].endY) and
							pointCandidate[1].strokelength < 60 then
						stat['pointOnHoriz']['point'][index] = nil
						break
					end
				end
			end
			stat['pointOnHoriz']['point'].compact!
			for horizCandidate in stat['pointOnHoriz']['horiz']
				hits = []
				for pointCandidate in stat['pointOnHoriz']['point']
					if ((horizCandidate[1].startX)..(horizCandidate[1].endX)).cover?(pointCandidate[1].endX) and
							((pointCandidate[1].endY - intersectThreshold)..(pointCandidate[1].endY + intersectThreshold)).cover?(horizCandidate[1].endY) then
						hits.push(pointCandidate)
					end
				end
				if hits.length == 1 then
					for diagonalCandidate in stat['pointOnHoriz']['diagonal']
						if ((horizCandidate[1].startX)..(horizCandidate[1].endX)).cover?(diagonalCandidate[1].endX) and
								((((hits[0][1].endY + hits[0][1].startY) / 2)..(hits[0][1].endY + intersectThreshold)).cover?(diagonalCandidate[1].endY) or
								(((hits[0][1].startY)..(hits[0][1].endY + hits[0][1].startY) / 2)).cover?(diagonalCandidate[1].startY)) then
							hits.push(diagonalCandidate)
						end
					end
				end
				if hits.length == 1 and hits[0][1].strokelength < 60 then
					index = hits[0][0]
					baseLength = [horizCandidate[1].endX - horizCandidate[1].startX, 100].min
					STDERR.write("#{glyph.name}: 鍋蓋・ウ冠の点をインデックス#{index}で検出！\n")
					stroke = hits[0][1]
					stroke.strokeType = 2
					stroke.startType = 7
					stroke.endType = 8
					stroke.startX -= (baseLength.to_f / 4).ceil
					stroke.control1Y -= ((stroke.endY - stroke.startY).to_f / 8).round
					stroke.endX += (baseLength.to_f / 20).ceil
					stroke.endY -= ((stroke.endY - stroke.startY).to_f / 5).round
					glyph[index] = stroke
				end
			end
		end
	end
	# デリファレンスを元に戻す
	if not stat['dereference'].empty? then
		tmpGlyph = glyph.to_a
		for index, stroke in stat['dereference'].each_pair
			tmpGlyph[index] = stroke
		end
		glyph.replace_with(tmpGlyph)
	end
	print "#{glyph.to_s}\n"
end
