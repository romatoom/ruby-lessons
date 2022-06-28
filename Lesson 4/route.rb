=begin
  Класс Route (Маршрут):
  Имеет начальную и конечную станцию, а также список промежуточных станций.
  Начальная и конечная станции указываются при создании маршрута, а промежуточные могут добавляться между ними.
  Может добавлять промежуточную станцию в список
  Может удалять промежуточную станцию из списка
  Может выводить список всех станций по-порядку от начальной до конечной
=end

class Route
  attr_reader :start_station
  attr_reader :finish_station
  attr_reader :intermediate_stations

  def initialize(start_station, finish_station)
    @start_station = start_station
    @finish_station = finish_station
    @intermediate_stations = []
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

  # скрываем доступ к непосредственному изменению промежуточных станций
  attr_writer :intermediate_stations
end
