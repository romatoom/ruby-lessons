require_relative "modules/instance_counter"
require_relative "modules/validation"
require_relative "station"

class Route
  include InstanceCounter

  include Validation

  attr_reader :start_station, :finish_station, :intermediate_stations

  validate :start_station, :type, Station
  validate :finish_station, :type, Station

  def initialize(start_station, finish_station)
    @start_station = start_station
    @finish_station = finish_station
    @intermediate_stations = []

    validate!

    register_instance
  end

  def add_intermediate_station_to_end(station)
    raise "Аргумент должен быть станцией" unless station.class.ancestors.include?(Station) && station.valid?

    intermediate_stations << station unless intermediate_stations.include?(station)
  end

  def add_intermediate_station_after_specified(station, specified_station)
    return if intermediate_stations.include?(station)

    index = intermediate_stations.find_index(specified_station)
    intermediate_stations.insert(index, station) unless index.nil?
  end

  def remove_intermediate_station(station)
    raise "Аргумент должен быть станцией" unless station.class.ancestors.include?(Station) && station.valid?

    intermediate_stations.delete(station)
  end

  def stations_list
    [start_station] + intermediate_stations + [finish_station]
  end

  def to_s
    stations_titles_list = stations_list.map(&:title)
    stations_titles_list.join(" => ")
  end

  private

  attr_writer :intermediate_stations
end
