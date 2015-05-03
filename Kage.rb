module Kage
	class Stroke
		def initialize(value)
			if value.is_a? String then
				@data = value.split(/:/)
				@data.each_with_index {|val, index|
					if @data[0].to_i == 99 and index == 7 then
						@data[index] = val.dup
					else
						@data[index] = val.to_i
					end
				}
			elsif value.is_a? Array then
				value.each_with_index {|val, index|
					if value[0].to_i == 99 and index == 7 then
						raise TypeError, "Not a String instance" unless val.is_a? String
					else
						raise TypeError, "Not a Fixnum instance" unless val.is_a? Fixnum
					end
				}
				@data = value.dup
				if value[0].to_i == 99 then
					@data[7] = value[7].dup
				end
			end
			@data = (@data + ([0] * 11))[0..10]
		end
		def initialize_copy(stroke)
			for index in 0..10
				if @data[index] then
					begin
						@data[index] = stroke[index].dup
					rescue TypeError
						@data[index] = stroke[index]
					end
				end
			end
		end
		def [](index)
			@data[index]
		end
		def ref?
			@data[0] == 99
		end
		def to_s
			@data.join(":")
		end
		def to_a
			@data.dup
		end
		def strokelength
			case @data[0]
			when 1
				return Math.hypot(@data[5] - @data[3], @data[6] - @data[4])
			when 2, 3, 4
				return Math.hypot(@data[5] - @data[3], @data[6] - @data[4]) +
					Math.hypot(@data[7] - @data[5], @data[8] - @data[6])
			when 6, 7
				return Math.hypot(@data[5] - @data[3], @data[6] - @data[4]) +
					Math.hypot(@data[7] - @data[5], @data[8] - @data[6]) +
					Math.hypot(@data[9] - @data[7], @data[10] - @data[8])
			else
				return nil
			end
		end
		def strokeType
			@data[0]
		end
		def startType
			@data[1]
		end
		def endType
			@data[2]
		end
		def strokeType=(val)
			raise TypeError, "Not a Fixnum instance" unless val.is_a? Fixnum
			origType = @data[0]
			case origType
			when 1
				case val
				when 1
				when 2, 3, 4
					@data.insert(5, (@data[3] + @data[5]) / 2, (@data[4] + @data[6]) / 2)
				when 6, 7
					@data.insert(5, (@data[3] * 2 + @data[5]) / 3, (@data[4] * 2 + @data[6]) / 3, (@data[3] + @data[5] * 2) / 3, (@data[4] + @data[6] * 2) / 3)
				else
					raise ArgumentError, "Stroke type is invalid"
				end
			when 2, 3, 4
				case val
				when 1
					@data[5..8] = @data[7..8]
				when 2, 3, 4
				when 6, 7
					@data[5..6] = [(@data[5] * 2 + @data[7]) / 3, (@data[6] * 2 + @data[8]) / 3, (@data[5] + @data[7] * 2) / 3, (@data[6] + @data[8] * 2) / 3]
				else
					raise ArgumentError, "Stroke type is invalid"
				end
			when 6, 7
				case val
				when 1
					@data[5..10] = @data[9..10]
				when 2, 3, 4
					@data[5..8] = [(@data[5] + @data[7]) / 2, (@data[6] + @data[8]) / 2]
				when 6, 7
				else
					raise ArgumentError, "Stroke type is invalid"
				end
			else
				raise ArgumentError, "Stroke type is invalid"
			end
			@data[0] = val
		end
		def startType=(val)
			raise TypeError, "Not a Fixnum instance" unless val.is_a? Fixnum
			@data[1] = val
		end
		def endType=(val)
			raise TypeError, "Not a Fixnum instance" unless val.is_a? Fixnum
			@data[2] = val
		end
		def startPoint
			case @data[0]
			when 1, 2, 3, 4, 6, 7, 99
				return @data[3..4].dup
			else
				return nil
			end
		end
		def controlPoint1
			case @data[0]
			when 2, 3, 4, 6, 7
				return @data[5..6].dup
			else
				return nil
			end
		end
		def controlPoint2
			case @data[0]
			when 2, 3, 4
				return @data[5..6].dup
			when 6, 7
				return @data[7..8].dup
			else
				return nil
			end
		end
		def controlPoint
			case @data[0]
			when 2, 3, 4
				return @data[5..6].dup
			when 6, 7
				return [@data[5..6].dup, @data[7..8].dup]
			else
				return nil
			end
		end
		def endPoint
			case @data[0]
			when 1, 99
				return @data[5..6]
			when 2, 3, 4
				return @data[7..8]
			when 6, 7
				return @data[9..10]
			else
				return nil
			end
		end
		def startPoint=(a)
			raise TypeError, "Not an Array of 2 Fixnum instances" unless a.is_a? Array and a.length == 2 and a.all?{|elem| elem.is_a? Fixnum}
			@data[3..4] = a
		end
		def controlPoint1=(a)
			raise TypeError, "Not an Array of 2 Fixnum instances" unless a.is_a? Array and a.length == 2 and a.all?{|elem| elem.is_a? Fixnum}
			case @data[0]
			when 2, 3, 4, 6, 7
				@data[5..6] = a
			else
				raise RuntimeError, "Stroke type is invalid"
			end
		end
		def controlPoint2=(a)
			raise TypeError, "Not an Array of 2 Fixnum instances" unless a.is_a? Array and a.length == 2 and a.all?{|elem| elem.is_a? Fixnum}
			case @data[0]
			when 2, 3, 4
				@data[5..6] = a
			when 6, 7
				@data[7..8] = a
			else
				raise RuntimeError, "Stroke type is invalid"
			end
		end
		def endPoint=(a)
			raise TypeError, "Not an Array of 2 Fixnum instances" unless a.is_a? Array and a.length == 2 and a.all?{|elem| elem.is_a? Fixnum}
			case @data[0]
			when 1, 99
				@data[5..6] = a
			when 2, 3, 4
				@data[7..8] = a
			when 6, 7
				@data[9..10] = a
			else
				raise RuntimeError, "Stroke type is invalid"
			end
		end
		def startX
			self.startPoint[0]
		end
		def startY
			self.startPoint[1]
		end
		def control1X
			self.controlPoint1[0]
		end
		def control1Y
			self.controlPoint1[1]
		end
		def control2X
			self.controlPoint2[0]
		end
		def control2Y
			self.controlPoint2[1]
		end
		def endX
			self.endPoint[0]
		end
		def endY
			self.endPoint[1]
		end
		def startX=(val)
			self.startPoint = [val, self.startY]
		end
		def startY=(val)
			self.startPoint = [self.startX, val]
		end
		def control1X=(val)
			self.controlPoint1 = [val, self.control1Y]
		end
		def control1Y=(val)
			self.controlPoint1 = [self.control1X, val]
		end
		def control2X=(val)
			self.controlPoint2 = [val, self.control2Y]
		end
		def control2Y=(val)
			self.controlPoint2 = [self.control2X, val]
		end
		def endX=(val)
			self.endPoint = [val, self.endY]
		end
		def endY=(val)
			self.endPoint = [self.endX, val]
		end
		def link_to
			if @data[0] == 99 then
				return @data[7].dup
			else
				return nil
			end
		end
		alias :at :[]
		alias :inspect :to_s
	end
	class Glyph
		include Enumerable
		def initialize(str)
			(@name, gStr) = str.split(/\t/)
			@name.gsub!(/\\@/, '@')
			@strokes = (gStr.split(/\$/)).map {|elem| Stroke.new(elem)}
			if (@strokes.reject {|stroke| stroke.strokeType == 0}).empty? then
				@strokes = @strokes.take(1)
			else
				@strokes.reject! {|stroke| stroke.strokeType == 0}
			end
		end
		def initialize_copy(glyph)
			for stroke, index in glyph.each_with_index
				@strokes[index] = stroke.dup
			end
		end
		def each
			for stroke in @strokes
				yield stroke
			end
		end
		def [](index)
			@strokes[index].dup
		end
		def []=(index, val)
			@strokes[index] = checkType(val)
		end
		def insert(nth, *val)
			for v in val.reverse
				@strokes.insert(nth, checkType(v))
			end
			self
		end
		def push(nth, *val)
			for v in val
				@strokes.push(nth, checkType(v))
			end
			self
		end
		def +(other)
			begin
				@strokes + checkType(other)
			rescue TypeError
				@strokes + other.map{|val| checkType(other)}
			end
		end
		def length
			@strokes.length
		end
		def to_s
			"#{@name}\t#{@strokes.map{|x| x.to_s}.join("$")}"
		end
		def alias?
			@strokes.length == 1 and @strokes[0][0..6] == [99, 0, 0, 0, 0, 200, 200]
		end
		def ref_only?
			@strokes.all? {|stroke| stroke[0] == 99}
		end
		def replace_with(arg)
			if arg.is_a? Array then
				tmpStrokes = []
				for stroke in arg
					tmpStrokes.push(stroke.is_a?(Stroke) ? stroke : Stroke.new(stroke))
				end
				@strokes = tmpStrokes
			elsif arg.is_a? String then
				@strokes = (arg.split(/\$/)).map {|elem| Stroke.new(elem)}
			else
				raise TypeError, "Invalid argument"
			end
			self
		end
		def unversioned_name
			return @name.gsub(/@\d+$/, "")
		end
		attr_reader :name
		attr_reader :strokes
		alias :at :[]
		alias :size :length
		alias :inspect :to_s
		private
		def checkType(val)
			if val.is_a? Stroke then
				val
			elsif val.is_a? Array then
				Stroke.new(val)
			else
				raise TypeError, "Not a Kage::Stroke instance"
			end
		end
	end
	
	def self.dist(from, to)
		for a in [from, to]
			raise TypeError, "Not an Array of 2 Numeric instances" unless a.is_a? Array and a.length == 2 and a.all?{|elem| elem.is_a? Numeric}
		end
		Math.hypot(to[0] - from[0], to[1] - from[1])
	end
end
