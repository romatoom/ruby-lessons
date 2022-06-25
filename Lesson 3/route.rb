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

  def initialize(start_station, finish_station)
    @start_station = start_station
    @finish_station = finish_station

    @intermediate_stations = []
  end

  # добавить промежуточную станцию в список
  def add_intermediate_station(station)
    @intermediate_stations << station
  end

  # удалить промежуточную станцию из списка
  def remove_intermediate_station(station)
    @intermediate_stations.delete(station)
  end

  # список всех станций по-порядку от начальной до конечной
  def all_stations
    [@start_station] + @intermediate_stations + [@finish_station]
  end
end
