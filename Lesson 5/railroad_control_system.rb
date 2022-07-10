require_relative "route"
require_relative "train/train"
require_relative "train/cargo_train"
require_relative "train/passenger_train"
require_relative "wagon/wagon"
require_relative "wagon/cargo_wagon"
require_relative "wagon/passenger_wagon"
require_relative "station"
require_relative "modules/interaction_helper"

class RailroadControlSystem
  extend InteractionHelper

  @stations = {}
  @trains = {}
  @routes = {}

  class << self
    def start
      puts "Система управления ЖД запущена"
      puts

      answer = input_value("Загрузить сиды (выполнить предварительные команды)? Введите Y, если согласны").downcase

      create_seeds if answer == "y"

      menu_control(:main_menu)

      stop
    end

    private

    attr_reader :stations, :trains, :routes

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

      routes["Москва Октябрьская - Санкт-Петербург-Главн."] =
        Route.new(stations["Москва Октябрьская"], stations["Санкт-Петербург-Главн."])
      routes["Москва Октябрьская - Санкт-Петербург-Главн."].add_intermediate_station_to_end(stations["Тверь"])
      routes["Москва Октябрьская - Санкт-Петербург-Главн."].add_intermediate_station_to_end(stations["Вышний Волочёк"])
      routes["Москва Октябрьская - Санкт-Петербург-Главн."].add_intermediate_station_to_end(stations["Бологое-Московское"])
      routes["Москва Октябрьская - Санкт-Петербург-Главн."].add_intermediate_station_to_end(stations["Малая Вишера"])

      routes["Санкт-Петербург-Главн. - Москва Октябрьская"] =
        Route.new(stations["Санкт-Петербург-Главн."], stations["Москва Октябрьская"])
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
      trains["П01-12"].move_to_next_station
      5.times { trains["П02МР"].move_to_next_station }

      puts "Поезда проехали часть маршрута (некоторое количество станций)\n\n"

      test_accessor

      test_validation_presence
      test_validation_format
      test_validation_type

      test_manufact

      puts "Генерация сидов завершена\n\n"
    end

    def test_accessor
      puts "Текущий производитель поезда: #{trains['Г01-АА'].manufacturer_title}"
      trains["Г01-АА"].manufacturer_title = "Новое название"
      trains["Г01-АА"].manufacturer_title = "Свежее название"
      trains["Г01-АА"].manufacturer_title = "Последнее название"
      puts "История наименований: #{trains['Г01-АА'].manufacturer_title_history}"

      puts "Текущий производитель поезда: #{trains['Г01-АА'].manufacturer_address}"
      trains["Г01-АА"].manufacturer_address = "Новый адрес"
      trains["Г01-АА"].manufacturer_address = "Более новый адрес"
      puts "История адресов: #{trains['Г01-АА'].manufacturer_address_history}\n\n"

      first_wagon = trains["Г01-АА"].find_wagon_by_number(1)
      first_wagon.number = "123"
    rescue RuntimeError => e
      puts "Error: #{e.message}"
    ensure
      puts
    end

    def test_validation_presence
      trains["Г123456"] = CargoTrain.new("")
    rescue RuntimeError => e
      puts "Error: #{e.message}"
    ensure
      puts
    end

    def test_validation_format
      trains["Г123456"] = CargoTrain.new("As-231123")
    rescue RuntimeError => e
      puts "Error: #{e.message}"
    ensure
      puts
    end

    def test_validation_type
      trains["Г123456"] = CargoTrain.new(12_345)
    rescue RuntimeError => e
      puts "Error: #{e.message}"
    ensure
      puts
    end

    def test_manufact
      puts "Поезд с номером #{trains['Г01-АА'].number} валидный? #{trains['Г01-АА'].valid?}"
      trains["Г01-АА"].manufacturer_title = 12_345
      puts "Меняем аттрибут manufacturer_title указанного поезда на невалидный"
      puts "Поезд с номером #{trains['Г01-АА'].number} валидный? #{trains['Г01-АА'].valid?}"
    rescue RuntimeError => e
      puts "Error: #{e.message}"
    ensure
      puts
    end

    def print_info_about_trains_on_stantions
      puts "Информация о поездах на станциях:\n\n"

      stations.each_value do |station|
        puts "Станция #{station.title}\n\n"

        station.each_trains do |train|
          print "  "
          Train.lambda_print_train.call(train)
          puts

          train.each_wagons do |wagon|
            print "    "
            Wagon.lambda_print_wagon.call(wagon)
          end

          puts
        end

        puts "--------------------------------\n\n"
      end

      puts
    end

    def create_station
      title = input_value("Введите название станции")

      if stations[title].nil?
        stations[title] = Station.new(title)

        puts "Станция создана\n\n"
      else
        puts "Станция с таким названием уже существует"
        print_command_cancel
      end
    end

    def print_stations_list
      print "Список станций: "

      if stations_titles_list.empty?
        puts "ни одной станции не найдено в системе\n\n"
      else
        puts "#{stations_titles_list.join(', ')}\n\n"
      end
    end

    def print_trains_on_station
      station = input_station
      return print_command_cancel if station.nil?

      passenger_trains = station.train_list_by_type(:passenger)
      cargo_trains = station.train_list_by_type(:cargo)

      return puts "На станции нет поездов\n\n" if passenger_trains.empty? && cargo_trains.empty?

      lambda_print_train = lambda do |train|
        puts "Номер: #{train.number}, вагонов: #{train.wagons_count}, " \
             "основной маршрут: #{train.route_title}"
      end

      unless passenger_trains.empty?
        puts "Пассажирские поезда на станции:"

        passenger_trains.each(&lambda_print_train)
        puts
      end

      return if cargo_trains.empty?

      puts "Грузовые поезда на станции:"

      cargo_trains.each(&lambda_print_train)
      puts
    end

    def print_trains_list_on_station
      station = input_station
      return print_command_cancel if station.nil?

      station.print_train_list
    end

    def create_train
      choice = input_value("Выберите тип поезда:\n0. Грузовой\n1. Пассажирский")

      raise "Ожидается ввод 0 или 1" unless ["0", "1", "^C"].include? choice

      type = choice.to_i.zero? ? :cargo : :passenger

      raise "Некорректный тип поезда" unless Train.allowed_types.include?(type)

      number = input_value("Введите номер поезда\n" \
                           "Формат номера: три буквы или цифры в любом порядке, необязательный дефис, затем ещё 2 буквы или цифры")

      trains[number] = type == :cargo ? CargoTrain.new(number) : PassengerTrain.new(number)

      answer = input_value("Хотите указать название производителя поезда? (Y - да)").downcase

      if answer == "y"
        trains[number].manufacturer_title = input_value("Укажите название производителя")

        raise "Неверно указано название производителя поезда" unless trains[number].valid?
      end
    rescue RuntimeError => e
      puts "Ошибка при создании поезда: #{e.message}\n\n"
      retry
    rescue Interrupt
      puts
      stop
    else
      puts "Поезд с номером #{number} создан\n\n"
    end

    def take_route_for_train
      train = input_train
      return print_command_cancel if train.nil?

      route = input_route
      return print_command_cancel if route.nil?

      train.take_route(route)

      puts "Поезд с номером #{train.number} получил маршрут #{train.route_title}\n\n"
    end

    def attach_wagons_to_train
      train = input_train
      return print_command_cancel if train.nil?

      wagons_count = input_value("Какое число вагонов с одинаковыми характеристиками прицепить?").to_i

      answer = input_value("Хотите указать название производителя вагонов? (Y - да)").downcase

      manufacturer_title = input_value("Укажите название производителя вагонов") if answer == "y"

      wagon_class = train.instance_of?(PassengerTrain) ? PassengerWagon : CargoWagon

      volume = if wagon_class == PassengerWagon
                 input_value("Какое общее число мест у вагонов?").to_i
               else
                 input_value("Каков объём у вагонов?").to_i
               end

      wagons_count.times { train.attach_wagon(wagon_class.new(volume, manufacturer_title)) }

      puts "К поезду с номером #{train.number} прицеплено #{wagons_count} вагонов\n\n"
    end

    def unhook_wagon_from_train
      train = input_train
      return print_command_cancel if train.nil?

      wagons_count = input_value("Какое число вагонов отцепить?")
      wagons_count = [wagons_count.to_i, train.wagons_count].min

      wagons_count.times { train.unhook_wagon }

      if train.wagons_count.zero?
        puts "От поезда с номером #{train.number} отцеплены все вагоны (#{wagons_count} штук)\n\n"
      else
        puts "От поезда с номером #{train.number} отцеплено #{wagons_count} вагонов\n\n"
      end
    end

    def move_train_to_next_station
      train = input_train
      return print_command_cancel if train.nil?

      station = train.current_station

      train.move_to_next_station

      current_station = train.current_station

      if station == current_station
        puts "Поезд остался на станции #{station.title}, так как она является конечной станцией маршрута\n\n"
      else
        puts "Поезд переместился по маршруту от станции #{station.title} на станцию #{current_station.title}"
        puts "Это конечная станция маршрута" if train.current_station == train.route.finish_station
        puts
      end
    end

    def move_train_to_previous_station
      train = input_train
      return print_command_cancel if train.nil?

      station = train.current_station

      train.move_to_previous_station

      current_station = train.current_station

      if station == current_station
        puts "Поезд остался на станции #{station.title}, так как она является начальной станцией маршрута\n\n"
      else
        puts "Поезд переместился обратно по маршруту от станции #{station.title} на станцию #{current_station.title}"
        puts "Это начальная станция маршрута" if train.current_station == train.route.start_station
        puts
      end
    end

    def print_train_wagons_list
      train = input_train
      return print_command_cancel if train.nil?

      puts "Список вагонов:"
      train.print_wagons_list
    end

    def take_wagon_volume
      train = input_train
      return print_command_cancel if train.nil?

      wagons_numbers = []

      train.each_wagons { |wagon| wagons_numbers << wagon.number.to_s }

      puts "Введите номер вагона, в котором нужно занять место"
      puts "Список доступных номеров вагонов: #{wagons_numbers.join(', ')}"
      print "> "

      wagon_number = input_from_list(wagons_numbers).to_i

      wagon = train.find_wagon_by_number(wagon_number)

      case wagon.type
      when :passenger
        return puts "Вагон полностью занят. Вы не можете занять место в этом вагоне\n\n" if wagon.number_of_empty_seats.zero?

        begin
          count = input_value("Какое число мест занять (доступно мест: #{wagon.number_of_empty_seats})?").to_i

          count.times { wagon.take_a_seat }
        rescue RuntimeError => e
          puts "Ошибка: #{e.message}\n\n"

          retry
        else
          puts "В вагоне №#{wagon.number} поезда номер #{train.number} занято #{count} мест\n\n"
        end
      when :cargo
        return puts "Вагон полностью занят. Вы не можете занять объём в этом вагоне\n\n" if wagon.available_volume.zero?

        begin
          volume = input_value("Какой объём вагона занять (доступный объём: #{wagon.available_volume})?").to_f

          wagon.take_a_volume(volume)
        rescue RuntimeError => e
          puts "Ошибка: #{e.message}\n\n"

          retry
        else
          puts "В вагоне №#{wagon.number} поезда номер #{train.number} занят объём в размере #{volume}\n\n"
        end
      end
    end

    def create_route
      start_station = input_station("Выбор начальной станции.")
      return print_command_cancel if start_station.nil?

      available_stations = stations_titles_list - [start_station.title]

      finish_station = input_station("Выбор конечной станции.", available_stations)
      return print_command_cancel if finish_station.nil?

      route_title = "#{start_station.title} - #{finish_station.title}"
      routes[route_title] = Route.new(start_station, finish_station)

      puts "Маршрут \"#{route_title}\" создан\n\n"
    end

    def push_intermediate_station_to_route
      route = input_route
      return print_command_cancel if route.nil?

      except_list = route.stations_list.map(&:title)

      available_stations = stations_titles_list - except_list

      station = input_station("Выбор станции, которую нужно вставить.", available_stations)
      return print_command_cancel if station.nil?

      route.add_intermediate_station_to_end(station)

      puts "Маршрут обновлён\nТекущий маршрут: #{route}\n\n"
    end

    def insert_intermediate_station_to_route
      route = input_route
      return print_command_cancel if route.nil?

      except_list = route.stations_list.map(&:title)

      available_stations = stations_titles_list - except_list

      station = input_station("Выбор станции, которую нужно вставить.", available_stations)
      return print_command_cancel if station.nil?

      intermediate_stations_titles = route.intermediate_stations.map(&:title)

      specified_station = input_station("Перед какой станцией вставить?", intermediate_stations_titles)
      return print_command_cancel if specified_station.nil?

      route.add_intermediate_station_after_specified(station, specified_station)

      puts "Маршрут обновлён\nТекущий маршрут: #{route}\n\n"
    end

    def input_train
      return puts "Ни один поезд ещё не создан в системе. Сначала создайте поезд\n\n" if trains_numbers_list.empty?

      puts "Введите номер поезда"
      puts "Список доступных номеров поездов: #{trains_numbers_list.join(', ')}\nДля отмены введите команду: cancel"
      print "> "

      number = input_from_list(trains_numbers_list)

      return print_command_cancel if number.nil?

      train = trains[number]

      puts "Поезд с номером #{number} не найден\n\n" if train.nil?

      train
    end

    def input_route
      return puts "Ни один маршрут ещё не создан в системе. Сначала создайте маршрут\n\n" if routes_titles_list.empty?

      puts "Введите маршрут"
      puts "Список доступных маршрутов: #{routes_titles_list.join(', ')}\nДля отмены введите команду: cancel"
      print "> "

      route_title = input_from_list(routes_titles_list)

      return print_command_cancel if route_title.nil?

      route = routes[route_title]

      puts "Маршрут #{route_title} не найден\n\n" if route.nil?

      route
    end

    def input_station(prefix = "", available_stations = stations_titles_list)
      return puts "Ни одна станция ещё не создана в системе. Сначала создайте станцию\n\n" if stations_titles_list.empty?

      return puts "Нет доступных для выбора станций\n\n" if available_stations.empty?

      print "#{prefix} " if prefix != ""
      puts "Введите название станции"
      puts "Доступные станции: #{available_stations.join(', ')}\nДля отмены введите команду: cancel"
      print "> "

      title = input_from_list(available_stations)

      return print_command_cancel if title.nil?

      station = stations[title]

      puts "Станция #{title} не найдена\n\n" if station.nil?

      station
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
