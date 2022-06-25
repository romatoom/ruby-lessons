# Just a file for simple testing

require_relative "route"
require_relative "train"
require_relative "station"

station_begin = Station.new("Начальная")

intermediate_stations_titles = ['Станция 1', 'Станция 2', 'Станция 3', 'Станция 4', 'Станция 5']

intermediate_stations = []

intermediate_stations_titles.each { |title| intermediate_stations << Station.new(title) }

station_end = Station.new("Конечная")

route = Route.new(station_begin, station_end)
intermediate_stations.each { |station| route.add_intermediate_station(station) }

trains = [
  Train.new("P-293494", "пассажирский", 9),
  Train.new("G-234234", "грузовой", 120),
  Train.new("P-834545", "пассажирский", 12),
  Train.new("P-348683", "пассажирский", 10),
  Train.new("G-139352", "грузовой", 100),
  Train.new("P-486734", "пассажирский", 15),
  Train.new("G-481246", "грузовой", 90)
]

trains.each { |train| train.take_route(route) }


trains[0].move_to_next_station

2.times { trains[1].move_to_next_station }

3.times { trains[2].move_to_next_station }

3.times { trains[3].move_to_next_station }

3.times { trains[4].move_to_next_station }

3.times { trains[5].move_to_next_station }

def print_trains_by_type(station)
  puts "Пассажирских поездов - #{station.train_list_by_type("Пассажирский").length}"
  puts "Грузовых поездов - #{station.train_list_by_type("Грузовой").length}"
end

def print_info(station_begin, intermediate_stations, station_end)
  puts "#{station_begin.title} :"
  station_begin.train_list.each { |t| puts t.number }
  print_trains_by_type(station_begin)
  puts

  intermediate_stations.each do |station|
    puts "#{station.title} :"
    station.train_list.each { |t| puts t.number }
    print_trains_by_type(station)
    puts
  end

  puts "#{station_end.title} :"
  station_end.train_list.each { |t| puts t.number }
  print_trains_by_type(station_end)
  puts
end

print_info(station_begin, intermediate_stations, station_end)
