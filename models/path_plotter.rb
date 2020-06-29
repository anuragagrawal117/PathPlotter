class PathPlotter

	GOOGLE_API_KEY = "AIzaSyAb8ohmBXqtK4y2_a5CFnFnfLGiOsuwjIo"
  GOOGLE_MAPS_BASE_URL = "https://maps.googleapis.com/"
  GOOGLE_DIRECTION_ENDPOINT = "maps/api/directions/json?"
  DISTANCE_INTERVAL = 50 # in meters
  RESPONSE_OK = "OK"


	attr_accessor :origin, :destination

	def initialize orig, dest
		@origin = orig
		@destination = dest
	end

  def plot
    plotted_coordinates = []
    remaining_distance = 0.0
    steps = fetch_steps
    geocoder_service = GeocoderService.new
    steps.each do |step|
      step_coordinates, remaining_distance = geocoder_service.get_plotted_coordinates(
        DISTANCE_INTERVAL, remaining_distance, step.polyline)
      plotted_coordinates += step_coordinates
    end
    return plotted_coordinates
  end

	def fetch_steps
    steps = []
    params = {
      origin: @origin.to_string,
      destination: @destination.to_string,
      key: GOOGLE_API_KEY
    }
    resp = RestClient.get(GOOGLE_MAPS_BASE_URL + GOOGLE_DIRECTION_ENDPOINT + URI.encode_www_form(params))
    if resp.code == 200
      resp_body = JSON.parse(resp.body)
      if resp_body["status"] == RESPONSE_OK
        resp_steps = resp_body["routes"].first["legs"].first["steps"] rescue nil
        if resp_steps.nil?
          p "steps not found!"
        else
          steps = resp_steps.map do |step|
            start_location = Coordinate.new(step["start_location"]["lat"], step["start_location"]["long"])
            end_location = Coordinate.new(step["end_location"]["lat"], step["end_location"]["long"])
            polyline = step["polyline"]["points"]
            Step.new(start_location, end_location, polyline)
          end
        end
      else
        p "response status from google api: #{resp_body["status"]}"
      end
    else
      p "google api failed with code #{resp.code}"
    end
    return steps
  end

end