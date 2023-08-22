#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/Kage.rb"

############################################################################

preInputGlyph = {
	'u5196-03' => Kage::Glyph.new("u5196-03\t2:7:8:18:22:27:43:27:59$1:0:2:23:31:176:31$2:22:7:176:31:170:43:156:63")
}
# U+4E0F 丏  U+4E31 丱  U+4EE5 以  U+53E2 叢  U+5433 吳
# U+5DE5 工  U+5DE9 巩  U+6B62 止  U+6B63 正  U+6B6F 歯
# U+6B72 歲  U+6B73 歳  U+723F 爿  U+7247 片  U+8033 耳
# U+8085 肅  U+8096 肖  U+8207 與  U+898D 覍  U+9F52 齒
# U+23D92 [淵-氵]  U+27D2A [瑣-王]
ignorePattern = /^(u(4e(0f|31|e5)|53d6|53e2|5433|5de[59]|5f0f|6b6[23f]|6b7[23]|723f|7247|80(33|85|96)|8207|898d|9f52|23d92|27d2a)|aj1-13760|cdp-89cd|j90-4c6c|u2ff1-cdp-8cfa-u5bf8)($|-|@\d+)/
nonKanjiPattern = /^u([01a-e][0-9a-f]{3}|(2[0-9a-d]|3[023]|f[0-8b-f])[0-9a-f]{2}|(2e[0-7]|2f[ef]|31[0-8abf]|4d[c-f])[0-9a-f]|([13-f]|10)[0-9a-f]{4})($|-|@\d+)/

############################################################################

# 特定の参照を解体
def dereference(stat, preInputGlyph, glyph)
	stat['dereference'] = {}
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
def find_radical_walk(stat, glyph) # 之繞
	stat['walkRadical'] = {'index' => nil, 'type' => nil, 'stat' => 0, 'tmpPos' => [nil, nil]}
	for stroke, index in glyph.each_with_index
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
	end
end
def find_special_l2rd(stat, glyph) # 特殊型右はらい
	stat['specialL2RD'] = {'index' => nil}
	for stroke, index in glyph.each_with_index
		if stroke[0..2] == [6, 7, 0] and stroke.control2Y >= stroke.endY and stat['walkRadical']['index'].nil? then
			stat['specialL2RD']['index'] = index
			STDERR.write("#{glyph.name}: 特殊型右はらいをインデックス#{index}で検出！\n")
		end
	end
end
def find_point_on_horiz(stat, glyph) # なべぶた・ウ冠
	stat['pointOnHoriz'] = {'horiz' => [], 'point' => [], 'diagonal' => []}
	for stroke, index in glyph.each_with_index
		if stroke[0] == 1 and stroke.startY == stroke.endY then
			stat['pointOnHoriz']['horiz'].push([index, stroke.dup])
		elsif stroke[0..1] == [1, 0] and stroke.startX == stroke.endX then
			stat['pointOnHoriz']['point'].push([index, stroke.dup])
		elsif (stroke[0..2] == [2, 7, 8] or stroke[0..2] == [2, 0, 7])and stroke.startY < stroke.endY then
			stat['pointOnHoriz']['diagonal'].push([index, stroke.dup])
		end
	end
end
def find_hook(stat, glyph) # 鈎（レの字）
	stat['hook'] = {'hook' => [], 'stem' => [], 'horiz' => []}
	for stroke, index in glyph.each_with_index
		if stroke.strokeType == 1 and stroke.startX == stroke.endX then
			stat['hook']['stem'].push([index, stroke.dup])
		elsif stroke.strokeType == 2 and stroke.endType == 7 and stroke.startY < stroke.endY then
			stat['hook']['stem'].push([index, stroke.dup])
		elsif stroke.strokeType == 1 and stroke.startY == stroke.endY then
			stat['hook']['horiz'].push([index, stroke.dup])
		elsif stroke[0..2] == [2, 0, 7] and stroke.startY > stroke.endY and stroke.startX < stroke.endX then
			stat['hook']['hook'].push([index, stroke.dup])
		end
	end
end
def find_roofed_l2rd(stat, glyph) # 屋根付き右はらい
	stat['l2rd'] = {'l2rd' => [], 'horiz' => []}
	for stroke, index in glyph.each_with_index
		if stroke.startType == 27 then
			stat['l2rd']['l2rd'].push([index, stroke.dup])
		elsif stroke.strokeType == 1 and stroke.startY == stroke.endY then
			stat['l2rd']['horiz'].push([index, stroke.dup])
		end
	end
end
def find_l2rd_bended_up(stat, glyph) # 上に反った右はらい
	stat['l2rd_up'] = []
	for stroke, index in glyph.each_with_index
		if stroke.strokeType == 2 and stroke.startY < stroke.endY and stroke.endY < stroke.control1Y then
			stat['l2rd_up'].push([index, stroke.dup])
		end
	end
end

# 特定部首を宋朝体字形に置換え
def replace_radical_walk(stat, glyph) # 之繞
	if not stat['walkRadical']['index'].nil? then
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
	return stat['walkRadical']['type'] == 1
end
def replace_special_l2rd(stat, glyph) # 特殊型右はらい
	if not stat['specialL2RD']['index'].nil? then
		index = stat['specialL2RD']['index']
		stroke = glyph[index]
		stroke.endY = stroke.control2Y
		stroke.controlPoint2 = stroke.controlPoint1
		stroke.strokeType = 2
		glyph[index] = stroke
		for xStroke, xIndex in glyph.each_with_index
			if xIndex != index then
				xStroke = glyph[xIndex]
				begin
					if (not xStroke.ref?) and ((stroke.control1X)..(stroke.endX)).cover?(xStroke.endX) and ((stroke.control1Y)..(stroke.endY)).cover?(xStroke.endY) then
						slope = (stroke.endY - stroke.control1Y).to_f / (stroke.endX - stroke.control1X).to_f
						yIntercept = stroke.control1Y.to_f - slope * stroke.control1X.to_f
						xStroke.endY = (xStroke.endX * slope + yIntercept - 3).round
						glyph[xIndex] = xStroke
					end
				rescue => evar
					STDERR.write("#{glyph.name}: インデックス#{index}のKageデータが正しくありません！！\n#{evar.to_s}\n")
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
def replace_point_on_horiz(stat, glyph) # なべぶた・ウ冠
	if not (stat['pointOnHoriz']['horiz'].empty? or stat['pointOnHoriz']['point'].empty?) then
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
				stroke.startY -= ((stroke.endY - stroke.startY).to_f / 5).round
				stroke.startY = 0 if stroke.startY < 0
				stroke.control1Y -= ((stroke.endY - stroke.startY).to_f / 5).round
				stroke.endX += (baseLength.to_f / 20).ceil
				stroke.endY -= ((stroke.endY - stroke.startY).to_f / 5).round
				glyph[index] = stroke
			end
		end
	end
end
def replace_hook(stat, glyph) # 鈎（レの字）
	if not (stat['hook']['hook'].empty? or stat['hook']['stem'].empty?) then
		intersectThreshold = 8
		for hookCandidate, index in stat['hook']['hook'].each_with_index
			intersectCount = 0
			slope = (hookCandidate[1].endY - hookCandidate[1].startY).to_f / (hookCandidate[1].endX - hookCandidate[1].startX).to_f
			yIntercept = hookCandidate[1].endY - slope * hookCandidate[1].endX
			for stemCandidate in stat['hook']['stem']
				intersectY = stemCandidate[1].endX * slope + yIntercept
				if ((hookCandidate[1].startX)..(hookCandidate[1].endX)).cover?(stemCandidate[1].endX) and
						((intersectY - intersectThreshold)..(intersectY + intersectThreshold)).cover?(stemCandidate[1].endY) then
					intersectCount += 1
				end
			end
			if intersectCount != 1 then
				stat['hook']['hook'][index] = nil
			end
		end
		stat['hook']['hook'].compact!
		for stemCandidate in stat['hook']['stem']
			hits = []
			for hookCandidate in stat['hook']['hook']
				slope = (hookCandidate[1].endY - hookCandidate[1].startY).to_f / (hookCandidate[1].endX - hookCandidate[1].startX).to_f
				yIntercept = hookCandidate[1].endY - slope * hookCandidate[1].endX
				intersectY = stemCandidate[1].endX * slope + yIntercept
				if ((hookCandidate[1].startX)..(hookCandidate[1].endX)).cover?(stemCandidate[1].endX) and
						((intersectY - intersectThreshold)..(intersectY + intersectThreshold)).cover?(stemCandidate[1].endY) then
					hits.push(hookCandidate)
				end
			end
			if hits.length == 1 and stemCandidate[1].strokeType == 1 then
				for horizCandidate in stat['hook']['horiz']
					if ((stemCandidate[1].startY + intersectThreshold)..(stemCandidate[1].endY - intersectThreshold)).cover?(horizCandidate[1].endY) and
							((horizCandidate[1].startX + intersectThreshold)..(horizCandidate[1].endX - intersectThreshold)).cover?(stemCandidate[1].endX) then
						hits.push(horizCandidate)
					end
				end
			end
			if hits.length == 1 and 
					(stemCandidate[1].endX - hits[0][1].startX).to_f / (hits[0][1].endX - hits[0][1].startX).to_f <= (stemCandidate[1].strokeType == 1 ? 0.5 : 0.333) then
				stroke = hits[0][1].dup
				stem   = stemCandidate[1].dup
				index  = hits[0][0]
				sIndex = stemCandidate[0]
				STDERR.write("#{glyph.name}: 鈎（レの字）をインデックス#{index}で検出！\n")
				if stem.strokeType == 1 then
					stroke.startX = (stem.endX - 8).round
				end
				slope = (stroke.endY - stroke.startY).to_f / (stroke.endX - stroke.startX).to_f
				yIntercept = stroke.endY - slope * stroke.endX
				stroke.control1Y = (stroke.control1X * slope + yIntercept).round + 1
				stem.endY = (stem.endX * slope + yIntercept).round
				if stem.strokeType == 1 then
					stem.endType = 32
				elsif stem.strokeType == 2 and stem.endX - stroke.startX > 8 then
					stem.endX = stroke.startX + 8
				end
				glyph[index] = stroke
				glyph[sIndex] = stem
			end
		end
	end
end
def replace_roofed_l2rd(stat, glyph) # 屋根付き右はらい
	if not (stat['l2rd']['l2rd'].empty? or stat['l2rd']['horiz'].empty?) then
		for horizCandidate in stat['l2rd']['horiz']
			for downCandidate in stat['l2rd']['l2rd']
				if horizCandidate[1].endPoint == downCandidate[1].startPoint then
					roof  = horizCandidate[1].dup
					index = horizCandidate[0]
					roofLength = roof.endX - roof.startX
					STDERR.write("#{glyph.name}: 屋根付き右はらいをインデックス#{index}で検出！\n")
					if roofLength > 25 then
						roof.startX = roof.endX - 25
						glyph[index] = roof
					end
				end
			end
		end
	end
end
def replace_l2rd_bended_up(stat, glyph) # 上に反った右はらい
	if not stat['l2rd_up'].empty? then
		for downStroke in stat['l2rd_up']
			stroke  = downStroke[1].dup
			index = downStroke[0]
			STDERR.write("#{glyph.name}: 上に反った右はらいをインデックス#{index}で検出！\n")
			stroke.control2Y, stroke.endY = stroke.endY, stroke.control2Y
			glyph[index] = stroke
		end
	end
end

# デリファレンスを元に戻す
def undo_dereference(stat, glyph)
	if stat.include?('dereference') and (not stat['dereference'].empty?) then
		tmpGlyph = glyph.to_a
		for index, stroke in stat['dereference'].each_pair
			tmpGlyph[index] = stroke
		end
		glyph.replace_with(tmpGlyph)
	end
end

############################################################################
# グリフごとにループ
while l = ARGF.gets
	l.chomp!
	begin
		glyph = Kage::Glyph.new(l)
	rescue NoMethodError
		STDERR.write("\e[33m\e[1m\e[41m#{l.split(/\t/)[0]}: 異常データ！！→#{l.split(/\t/)[1]}\n\e[0m")
		print "#{l}\n"
		next
	end
	stat = {}
	if glyph.name =~ ignorePattern then
		# パターンに当てはまるグリフはスルー
	elsif glyph.name =~ nonKanjiPattern then
		# 非漢字は無視
	elsif not glyph.ref_only? then
		# 特定の参照を解体
		dereference(stat, preInputGlyph, glyph)
		# 特定部首検出
		find_radical_walk(stat, glyph)
		find_special_l2rd(stat, glyph)
		find_point_on_horiz(stat, glyph)
		find_hook(stat, glyph)
		find_roofed_l2rd(stat, glyph)
		find_l2rd_bended_up(stat, glyph)
		# 特定部首を宋朝体字形に置換え
		if replace_radical_walk(stat, glyph) then
			STDERR.write("#{glyph.name}: 再計算を行います\n")
			find_special_l2rd(stat, glyph)
			find_point_on_horiz(stat, glyph)
			find_hook(stat, glyph)
			find_roofed_l2rd(stat, glyph)
			find_l2rd_bended_up(stat, glyph)
		end
		replace_special_l2rd(stat, glyph)
		replace_point_on_horiz(stat, glyph)
		replace_hook(stat, glyph)
		replace_roofed_l2rd(stat, glyph)
		replace_l2rd_bended_up(stat, glyph)
	end
	# デリファレンスを元に戻す
	undo_dereference(stat, glyph)
	print "#{glyph.to_s}\n"
end
