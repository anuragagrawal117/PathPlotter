Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '*.rb')].each { |file| require file }
require 'rest-client'
require 'byebug'
require 'json'
require "fast_polylines"
require "geokit"

class PathPlotterService

  def self.run
    original = Coordinate.new(28.534693, 77.260178)
    destination = Coordinate.new(28.455473, 77.021904)
    path_plotter = PathPlotter.new(original, destination)
    plotted_coordinates = path_plotter.plot
    plotted_coordinates.each do |coordinate|
      p "#{coordinate.to_string}"
    end
  end
end