require_relative "route"
require_relative "train/train"
require_relative "train/cargo_train"
require_relative "train/passenger_train"
require_relative "wagon/wagon"
require_relative "wagon/cargo_wagon"
require_relative "wagon/passenger_wagon"
require_relative "station"

class RailroadControlSystem
  @@stations = {}
  @@trains = {}
  @@routes = {}

  class << self
    def start
      puts "Система управления ЖД запущена"
      puts
      puts "Загрузить сиды (выполнить предварительные команды)? Введите Y, если согласны"
      print "> "

      answer = gets.chomp.downcase
      puts

      create_seeds if answer == "y"

      loop do
        puts "Главное меню. Введите команду:"
        puts "0. Завершить работу"
        puts "1. Управление станциями"
        puts "2. Управление поездами"
        puts "3. Управление маршрутами"
        puts "4. Информация о поездах на станциях"
        print "> "

        choice = gets.chomp.to_i
        puts

        break if choice.zero?

        case choice
        when 1
          manage_stations
        when 2
          manage_trains
        when 3
          manage_routes
        when 4
          print_info_about_trains_on_stantions
        end
      end

      stop
    end

    private

    def stations
      @@stations
    end

    def trains
      @@trains
    end

    def routes
      @@routes
    end

    def stop
      puts "Система управления ЖД остановлена"
      exit
    end

    def create_seeds
      puts "Генерация сидов запущена"

      stations["Москва Октябрьская"] = Station.new("Москва Октябрьская")
      stations["Тверь"] = Station.new("Тверь")
      stations["Вышний Волочёк"] = Station.new("Вышний Волочёк")
      stations["Бологое-Московское"] = Station.new("Бологое-Московское")
      stations["Малая Вишера"] = Station.new("Малая Вишера")
      stations["Санкт-Петербург-Главн."] = Station.new("Санкт-Петербург-Главн.")

      puts "Созданы станции"

      routes["Москва Октябрьская - Санкт-Петербург-Главн."] = Route.new(stations["Москва Октябрьская"], stations["Санкт-Петербург-Главн."])
      routes["Москва Октябрьская - Санкт-Петербург-Главн."].add_intermediate_station_to_end(stations["Тверь"])
      routes["Москва Октябрьская - Санкт-Петербург-Главн."].add_intermediate_station_to_end(stations["Вышний Волочёк"])
      routes["Москва Октябрьская - Санкт-Петербург-Главн."].add_intermediate_station_to_end(stations["Бологое-Московское"])
      routes["Москва Октябрьская - Санкт-Петербург-Главн."].add_intermediate_station_to_end(stations["Малая Вишера"])

      routes["Санкт-Петербург-Главн. - Москва Октябрьская"] = Route.new(stations["Санкт-Петербург-Главн."], stations["Москва Октябрьская"])
      routes["Санкт-Петербург-Главн. - Москва Октябрьская"].add_intermediate_station_to_end(stations["Малая Вишера"])
      routes["Санкт-Петербург-Главн. - Москва Октябрьская"].add_intermediate_station_to_end(stations["Бологое-Московское"])
      routes["Санкт-Петербург-Главн. - Москва Октябрьская"].add_intermediate_station_to_end(stations["Вышний Волочёк"])
      routes["Санкт-Петербург-Главн. - Москва Октябрьская"].add_intermediate_station_to_end(stations["Тверь"])

      puts "Созданы маршруты"

      trains["Г01-АА"] = CargoTrain.new("Г01-АА")
      trains["Г02-33"] = CargoTrain.new("Г02-33")
      trains["Г03ПЧ"] = CargoTrain.new("Г03ПЧ")
      trains["П01-12"] = PassengerTrain.new("П01-12")
      trains["П02МР"] = PassengerTrain.new("П02МР")

      puts "Созданы поезда"

      trains["Г01-АА"].take_route(routes["Москва Октябрьская - Санкт-Петербург-Главн."])
      trains["Г02-33"].take_route(routes["Санкт-Петербург-Главн. - Москва Октябрьская"])
      trains["Г03ПЧ"].take_route(routes["Москва Октябрьская - Санкт-Петербург-Главн."])
      trains["П01-12"].take_route(routes["Санкт-Петербург-Главн. - Москва Октябрьская"])
      trains["П02МР"].take_route(routes["Москва Октябрьская - Санкт-Петербург-Главн."])

      puts "Поезда проставлены на маршруты"

      2.times { trains["Г01-АА"].attach_wagon(CargoWagon.new(500)) }
      3.times { trains["Г01-АА"].attach_wagon(CargoWagon.new(600, "Рузхиммаш")) }
      4.times { trains["Г01-АА"].attach_wagon(CargoWagon.new(700, "ПО \"Вагонмаш\"")) }
      5.times { trains["Г01-АА"].attach_wagon(CargoWagon.new(800, "Калининградский вагоностроительный завод")) }

      6.times { trains["Г02-33"].attach_wagon(CargoWagon.new(800)) }
      12.times { trains["Г03ПЧ"].attach_wagon(CargoWagon.new(750)) }
      2.times { trains["П01-12"].attach_wagon(PassengerWagon.new(54)) }
      3.times { trains["П02МР"].attach_wagon(PassengerWagon.new(48)) }

      puts "К поездам присоединены вагоны"

      trains["Г01-АА"].move_to_next_station
      2.times { trains["Г02-33"].move_to_next_station }
      4.times { trains["Г03ПЧ"].move_to_next_station }
      1.times { trains["П01-12"].move_to_next_station }
      5.times { trains["П02МР"].move_to_next_station }

      puts "Поезда проехали часть маршрута (некоторое количество станций)"

      puts "Генерация сидов завершена"
      puts

      trains["Г01-АА"].manufacturer_title = "Уральские локомотивы"
      puts "Производитель поезда с номером Г01-АА: " + trains["Г01-АА"].manufacturer_title
      puts

      trains["Г01-АА"].print_wagons_manufacturers

      puts "Station.all:"
      puts Station.all
      puts

      puts "Train.find(\"Г01-АА\"):"
      puts Train.find("Г01-АА")
      puts

      puts "Train.find(\"Г12-ПР\"):"
      p Train.find("Г12-ПР")
      puts

      puts "Route instances count: " + Route.instances.to_s
      puts "Station instances count: " + Station.instances.to_s
      puts "PassengerTrain instances count: " + PassengerTrain.instances.to_s
      puts "CargoTrain instances count: " + CargoTrain.instances.to_s
      puts

      train_number = "ПЗД-01"

      # train_number = "WRONG_NUMBER"

      # train = Train.new(train_number, :cargo)

      trains[train_number] = PassengerTrain.new(train_number)
      puts

    rescue Exception => e
      puts "Ошибка при создании поезда (#{e.message})"
      puts
      raise
    ensure
      if trains[train_number]
        puts "Поезд с номером #{train_number} проходит проверку? " + trains[train_number].valid?.to_s
        puts
      end

      puts "Список номеров всех поездов: "
      Train.all.each { |t| puts t.number }
      puts
    end

    def manage_stations
      loop do
        puts "Меню управления станциями. Введите команду:"
        puts "0. Назад (в главное меню)"
        puts "1. Создать станцию"
        puts "2. Посмотреть список станций"
        puts "3. Просмотреть список поездов на станции (детально)"
        puts "4. Просмотреть список поездов на станции (общий)"
        print "> "

        choice = gets.chomp.to_i
        puts

        break if choice.zero?

        case choice
        when 1
          create_station
        when 2
          print_stations_list
        when 3
          print_trains_on_station
        when 4
          print_trains_list_on_station
        end
      end
    end

    def manage_trains
      loop do
        puts "Меню управления поездами. Введите команду:"
        puts "0. Назад (в главное меню)"
        puts "1. Создать поезд"
        puts "2. Назначить маршрут поезду"
        puts "3. Добавить вагоны к поезду"
        puts "4. Отцепить вагоны от поезда"
        puts "5. Переместить поезд по маршруту вперед"
        puts "6. Переместить поезд по маршруту назад"
        puts "7. Вывести список вагонов"
        puts "8. Занять место в вагоне"
        print "> "

        choice = gets.chomp.to_i
        puts

        break if choice.zero?

        case choice
        when 1
          create_train
        when 2
          take_route_for_train
        when 3
          attach_wagons_to_train
        when 4
          unhook_wagon_from_train
        when 5
          move_train_to_next_station
        when 6
          move_train_to_previous_station
        when 7
          print_train_wagons_list
        when 8
          take_wagon_volume
        end
      end
    end

    def manage_routes
      loop do
        puts "Меню управления маршрутами. Введите команду:"
        puts "0. Назад (в главное меню)"
        puts "1. Создать маршрут"
        puts "2. Добавить промежуточную станцию (перед конечной станцией)"
        puts "3. Добавить промежуточную станцию (в другое место в маршруте)"
        print "> "

        choice = gets.chomp.to_i
        puts

        break if choice.zero?

        case choice
        when 1
          create_route
        when 2
          push_intermediate_station_to_route
        when 3
          insert_intermediate_station_to_route
        end
      end
    end

    def print_info_about_trains_on_stantions
      puts "Информация о поездах на станциях:"
      puts

      stations.each_value do |station|
        puts "Станция #{station.title}"
        puts

        station.each_trains do |train|
          print "  "
          Station.lambda_print_trains.call(train)
          puts

          train.each_wagons do |wagon|
            print "    "
            Train.lambda_print_wagons.call(wagon)
          end

          puts
        end

        puts "--------------------------------"
        puts
      end

      puts
    end

    def create_station
      puts "Введите название станции"
      print "> "

      title = gets.chomp

      if stations[title].nil?
        stations[title] = Station.new(title)

        puts "Станция создана"
      else
        puts "Станция с таким названием уже существует"
        puts "Текущая команда отменена"
      end

      puts
    end

    def print_stations_list
      print "Список станций: "

      if stations_titles_list.empty?
        puts "ни одной станции не найдено в системе"
      else
        puts stations_titles_list.join(", ")
      end

      puts
    end

    def print_trains_on_station
      station = input_station
      return command_cancel if station.nil?

      passenger_trains = station.train_list_by_type(:passenger)
      cargo_trains = station.train_list_by_type(:cargo)

      if (passenger_trains.empty? && cargo_trains.empty?)
        puts "На станции нет поездов"
        puts

        return
      end

      if !passenger_trains.empty?
        puts "Пассажирские поезда на станции:"

        passenger_trains.each do |train|
          puts "Номер: #{train.number}, вагонов: #{train.wagons_count}, " +
            "основной маршрут: #{train.route_title}"
        end
      end

      if !cargo_trains.empty?
        puts "\nГрузовые поезда на станции:"

        cargo_trains.each do |train|
          puts "Номер: #{train.number}, вагонов: #{train.wagons_count}, " +
            "основной маршрут: #{train.route_title}"
        end
      end

      puts
    end

    def print_trains_list_on_station
      station = input_station
      return command_cancel if station.nil?

      station.print_train_list
      puts
    end

    def create_train
      puts "Выберите тип поезда:"
      puts "0. Грузовой"
      puts "1. Пассажирский"
      print "> "

      choice = gets.chomp
      puts

      raise "Ожидается ввод 0 или 1" unless ["0", "1", "^C"].include? choice

      case choice.to_i
      when 0
        type = :cargo
      when 1
        type = :passenger
      end

      raise "Некорректный тип поезда" unless Train.allowed_types.include? type

      puts "Введите номер поезда"
      puts "Формат номера: три буквы или цифры в любом порядке, необязательный дефис, затем ещё 2 буквы или цифры"
      print "> "

      number = gets.chomp
      puts

      case type
      when :cargo
        trains[number] = CargoTrain.new(number)
      when :passenger
        trains[number] = PassengerTrain.new(number)
      end

      puts "Хотите указать название производителя поезда? (Y - да)"
      print "> "

      answer = gets.chomp.downcase
      puts

      if answer == "y"
        puts "Укажите название производителя"
        print "> "

        trains[number].manufacturer_title = gets.chomp
        puts

        raise "Неверно указано название производителя поезда" unless trains[number].valid?
      end

    rescue RuntimeError => e
      puts "Ошибка при создании поезда: #{e.message}"
      puts
      retry
    rescue Interrupt
      puts
      stop
    else
      puts "Поезд с номером #{number} создан"
      puts
    end

    def take_route_for_train
      train = input_train
      return command_cancel if train.nil?

      route = input_route
      return command_cancel if route.nil?

      train.take_route(route)

      puts "Поезд с номером #{train.number} получил маршрут #{train.route_title}"
      puts
    end

    def attach_wagons_to_train
      train = input_train
      return command_cancel if train.nil?

      puts "Какое число вагонов с одинаковыми характеристиками прицепить?"
      print "> "

      wagons_count = gets.chomp.to_i

      puts "Хотите указать название производителя поезда? (Y - да)"
      print "> "

      answer = gets.chomp.downcase
      puts

      if answer == "y"
        puts "Укажите название производителя вагонов"
        print "> "

        manufacturer_title = gets.chomp
      end

      case train.class
      when PassengerTrain
        puts "Какое общее число мест у вагонов?"
        print "> "

        volume = gets.chomp.to_i

        wagons_count.times { train.attach_wagon(PassengerWagon.new(volume, manufacturer_title)) }
      when CargoTrain
        puts "Каков объём у вагонов?"
        print "> "

        volume = gets.chomp.to_i

        wagons_count.times { train.attach_wagon(CargoWagon.new(volume, manufacturer_title)) }
      end

      puts "К поезду с номером #{train.number} прицеплено #{wagons_count} вагонов"
      puts
    end

    def unhook_wagon_from_train
      train = input_train
      return command_cancel if train.nil?

      puts "Какое число вагонов отцепить?"
      print "> "

      wagons_count = [gets.chomp.to_i, train.wagons_count].min
      puts

      wagons_count.times { train.unhook_wagon }

      if train.wagons_count.zero?
        puts "От поезда с номером #{train.number} отцеплены все вагоны (#{wagons_count} штук)"
      else
        puts "От поезда с номером #{train.number} отцеплено #{wagons_count} вагонов"
      end

      puts
    end

    def move_train_to_next_station
      train = input_train
      return command_cancel if train.nil?

      station = train.current_station

      train.move_to_next_station

      current_station = train.current_station

      if station != current_station
        puts "Поезд переместился по маршруту от станции #{station.title} на станцию #{current_station.title}"
        puts "Это конечная станция маршрута" if train.current_station == train.route.finish_station
      else
        puts "Поезд остался на станции #{station.title}, так как она является конечной станцией маршрута"
      end

      puts
    end

    def move_train_to_previous_station
      train = input_train
      return command_cancel if train.nil?

      station = train.current_station

      train.move_to_previous_station

      current_station = train.current_station

      if station != current_station
        puts "Поезд переместился обратно по маршруту от станции #{station.title} на станцию #{current_station.title}"
        puts "Это начальная станция маршрута" if train.current_station == train.route.start_station
      else
        puts "Поезд остался на станции #{station.title}, так как она является начальной станцией маршрута"
      end

      puts
    end

    def print_train_wagons_list
      train = input_train
      return command_cancel if train.nil?

      puts "Список вагонов:"
      train.print_wagons_list
      puts
    end

    def take_wagon_volume
      train = input_train
      return command_cancel if train.nil?

      wagons_numbers = []

      train.each_wagons { |wagon| wagons_numbers << wagon.number.to_s }

      puts "Введите номер вагона, в котором нужно занять место"
      puts "Список доступных номеров вагонов: " + wagons_numbers.join(", ")
      print "> "

      wagon_number = input_from_list(wagons_numbers).to_i

      wagon = train.find_wagon_by_number(wagon_number)

      case wagon.type
      when :passenger
        if wagon.number_of_empty_seats == 0
          puts "Вагон полностью занят. Вы не можете занять место в этом вагоне"
          puts

          return
        end

        begin
          puts "Какое число мест занять (доступно мест: #{wagon.number_of_empty_seats})?"
          print "> "

          count = gets.chomp.to_i
          puts

          count.times { wagon.take_a_seat }

        rescue RuntimeError => e
          puts "Ошибка: " + e.message
          puts

          retry
        else
          puts "В вагоне №#{wagon.number} поезда номер #{train.number} занято #{count} мест"
        end
      when :cargo
        if wagon.available_volume == 0
          puts "Вагон полностью занят. Вы не можете занять объём в этом вагоне"
          puts

          return
        end

        begin
          puts "Какой объём вагона занять (доступный объём: #{wagon.available_volume})?"
          print "> "

          volume = gets.chomp.to_f
          puts

          wagon.take_a_volume(volume)
        rescue RuntimeError => e
          puts "Ошибка: " + e.message
          puts

          retry
        else
          puts "В вагоне №#{wagon.number} поезда номер #{train.number} занят объём в размере #{volume}"
        end
      end

      puts
    end

    def create_route
      start_station = input_station("Выбор начальной станции.")
      return command_cancel if start_station.nil?

      available_stations = stations_titles_list - [start_station.title]

      finish_station = input_station("Выбор конечной станции.", available_stations)
      return command_cancel if finish_station.nil?

      route_title = "#{start_station.title} - #{finish_station.title}"
      routes[route_title] = Route.new(start_station, finish_station)

      puts "Маршрут \"#{route_title}\" создан"
      puts
    end

    def push_intermediate_station_to_route
      route = input_route
      return command_cancel if route.nil?

      except_list = route.stations_list.map { |station| station.title }

      available_stations = stations_titles_list - except_list

      station = input_station("Выбор станции, которую нужно вставить.", available_stations)
      return command_cancel if station.nil?

      route.add_intermediate_station_to_end(station)

      puts "Маршрут обновлён"
      puts "Текущий маршрут: " + route.to_s
      puts
    end

    def insert_intermediate_station_to_route
      route = input_route
      return command_cancel if route.nil?

      except_list = route.stations_list.map { |station| station.title }

      available_stations = stations_titles_list - except_list

      station = input_station("Выбор станции, которую нужно вставить.", available_stations)
      return command_cancel if station.nil?

      intermediate_stations_titles = route.intermediate_stations.map { |station| station.title }

      specified_station = input_station("Перед какой станцией вставить?", intermediate_stations_titles)
      return command_cancel if specified_station.nil?

      route.add_intermediate_station_after_specified(station, specified_station)

      puts "Маршрут обновлён"
      puts "Текущий маршрут: " + route.to_s
      puts
    end

    def input_train
      if trains_numbers_list.empty?
        puts "Ни один поезд ещё не создан в системе. Сначала создайте поезд"
        puts

        return
      end

      puts "Введите номер поезда"
      puts "Список доступных номеров поездов: " + trains_numbers_list.join(", ")
      puts "Для отмены введите команду: cancel"
      print "> "

      number = input_from_list(trains_numbers_list)

      if number.nil?
        puts "Выбор поезда отменён"
        puts

        return
      end

      train = trains[number]

      if train.nil?
        puts "Поезд с номером #{number} не найден"
        puts
      end

      train
    end

    def input_route
      if routes_titles_list.empty?
        puts "Ни один маршрут ещё не создан в системе. Сначала создайте маршрут"
        puts

        return
      end

      puts "Введите маршрут"
      puts "Список доступных маршрутов: " + routes_titles_list.join(", ")
      puts "Для отмены введите команду: cancel"
      print "> "

      route_title = input_from_list(routes_titles_list)

      if route_title.nil?
        puts "Выбор маршрута отменён"
        puts

        return
      end

      route = routes[route_title]

      if route.nil?
        puts "Маршрут #{route_title} не найден"
        puts
      end

      route
    end

    def input_station(prefix = "", available_stations = stations_titles_list)
      if stations_titles_list.empty?
        puts "Ни одна станция ещё не создана в системе. Сначала создайте станцию"
        puts

        return
      end

      if available_stations.empty?
        puts "Нет доступных для выбора станций"
        puts

        return
      end

      print "#{prefix} " if prefix != ""
      puts "Введите название станции"
      puts "Доступные станции: " + available_stations.join(", ")
      puts "Для отмены введите команду: cancel"
      print "> "

      title = input_from_list(available_stations)

      if title.nil?
        puts "Выбор станции отменён"
        puts

        return
      end

      station = stations[title]

      if station.nil?
        puts "Станция #{title} не найдена"
        puts
      end

      station
    end

    def input_from_list(list)
      return if list.length.zero?

      loop do
        input = gets.chomp
        puts

        break if input == "cancel"

        if list.include?(input)
          return input
        else
          puts "Нужно ввести значение из списка: " + list.join(", ")
          puts "Для отмены введите команду: cancel"
          print "> "
        end
      end
    end

    def command_cancel
      puts "Выполнение команды было прервано"
      puts
    end

    def trains_numbers_list
      trains.keys
    end

    def stations_titles_list
      stations.keys
    end

    def routes_titles_list
      routes.keys
    end
  end
end
