require_relative "modules/instance_counter"

class Route
  include InstanceCounter

  attr_reader :start_station, :finish_station, :intermediate_stations

  def initialize(start_station, finish_station)
    @start_station = start_station
    @finish_station = finish_station
    @intermediate_stations = []
    register_instance
  end

  def add_intermediate_station_to_end(station)
    intermediate_stations << station unless intermediate_stations.include?(station)
  end

  def add_intermediate_station_after_specified(station, specified_station)
    unless intermediate_stations.include?(station)
      index = intermediate_stations.find_index(specified_station)
      intermediate_stations.insert(index, station) unless index.nil?
      index
    end
  end

  def remove_intermediate_station(station)
    intermediate_stations.delete(station)
  end

  def stations_list
    [start_station] + intermediate_stations + [finish_station]
  end

  def to_s
    stations_titles_list = stations_list.map { |station| station.title }
    stations_titles_list.join(" => ")
  end

  private

  attr_writer :intermediate_stations
end
