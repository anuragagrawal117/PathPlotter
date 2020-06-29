class Step

  attr_accessor :start_location, :end_location, :polyline

  def initialize(start_location, end_location, polyline)
    @start_location = start_location
    @end_location = end_location
    @polyline = polyline
  end


end