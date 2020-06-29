class Coordinate

  attr_accessor :x, :y

  def initialize(x, y)
  	@x = x
  	@y = y
  end

  def to_string
  	"#{@x},#{@y}"
  end

  def to_array
  	return [@x, @y]
  end

end