module Kage
	class Stroke
		def initialize(value)
			if value.is_a? String then
				@data = value.split(/:/)
				@data.each_with_index {|val, index|
					if @data[0].to_i == 99 and index == 7 then
						@data[index] = val
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
				@data = value
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
			@data.clone
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
		alias :at :[]
		alias :inspect :to_s
	end
	class Glyph
		include Enumerable
		def initialize(str)
			(@name, gStr) = str.split(/\t/)
			@strokes = (gStr.split(/\$/)).map {|elem| Stroke.new(elem)}
		end
		def each
			for stroke in @strokes
				yield stroke
			end
		end
		def [](index)
			@strokes[index]
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
end
