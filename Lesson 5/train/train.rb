require_relative "../modules/manufacturer"
require_relative "../modules/instance_counter"
require_relative "../modules/is_valid"

class Train
  include InstanceCounter

  include Manufacturer

  include IsValid

  # три буквы или цифры в любом порядке, необязательный дефис (может быть, а может нет) и еще 2 буквы или цифры после дефиса.
  NUMBER_FORMAR = /^[а-яa-z\d]{3}-?[а-яa-z\d]{2}$/i

  ALLOWED_TYPES = [:cargo, :passenger]

  @@all = []

  class << self
    def lambda_print_wagons
      ->(wagon) do
        case wagon.type
        when :passenger
          free_value = wagon.number_of_empty_seats
          taked_value = wagon.number_of_taked_seats
        when :cargo
          free_value = wagon.available_volume
          taked_value = wagon.taked_volume
        end

        puts "#{wagon.number}, #{wagon.type}, #{free_value}, #{taked_value}"
      end
    end

    def find(number)
      @@all.find { |train| train.number == number }
    end

    def all
      @@all
    end

    def allowed_types
      ALLOWED_TYPES
    end
  end

  attr_reader :speed, :type, :number, :route, :current_station

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
    @current_station = nil
    @wagons = []
    @manufacturer_title = "Производитель не указан"

    validate!

    @@all << self
    register_instance
  end

  def wagons_count
    wagons.length
  end

  def attach_wagon(wagon)
    raise "Аргумент должен быть вагоном" unless wagon.class.ancestors.include?(Wagon) && wagon.valid?

    wagon.number = wagons_count + 1

    wagons << wagon if speed == 0 && wagon.type == type
  end

  def unhook_wagon
    wagons.pop if (speed == 0) && (wagons_count > 0)
  end

  def print_wagons_manufacturers
    manufacturers_counts = Hash.new(0)

    wagons.each { |wagon| manufacturers_counts[wagon.manufacturer_title] += 1 }

    puts "Производители вагонов поезда c номером #{self.number}:"

    manufacturers_counts.each { |k, v| puts "\"#{k}\": число вагонов - #{v}" }
    puts
  end

  def take_route(route)
    raise "Аргумент должен быть маршрутом" unless route.class.ancestors.include?(Route) && route.valid?

    self.route = route

    route.start_station.take_train(self)
    self.current_station = route.start_station
  end

  def route_title
    if !route.nil?
      "#{route.start_station.title} - #{route.finish_station.title}"
    else
      "Маршрут не назначен"
    end
  end

  def move_to_next_station
    return if next_station.nil?

    destination = next_station

    current_station.send_train(self)
    self.current_station = nil

    pick_up_speed(max_speed)

    stay

    self.current_station = destination
    current_station.take_train(self)
  end

  def move_to_previous_station
    return if previous_station.nil?

    destination = previous_station

    current_station.send_train(self)
    self.current_station = nil

    pick_up_speed(max_speed)

    stay

    self.current_station = destination
    current_station.take_train(self)
  end

  def previous_station
    index = route.stations_list.find_index(current_station)

    if index > 0
      route.stations_list[index - 1]
    else
      nil
    end
  end

  def next_station
    index = route.stations_list.find_index(current_station)

    if index < route.stations_list.length - 1
      route.stations_list[index + 1]
    else
      nil
    end
  end

  def pick_up_speed(speed)
    pick_up_speed!(speed) if speed <= max_speed
  end

  def stay
    stay! if speed > 0
  end

  def each_wagons(&block)
    return until block_given?

    wagons.each { |wagon| yield wagon }
  end

  # Номер вагона (можно назначать автоматически), тип вагона, кол-во свободных и занятых мест (для пассажирского вагона) или кол-во свободного и занятого объема (для грузовых вагонов).
  def print_wagons_list
    each_wagons(&Train.lambda_print_wagons)
  end

  def find_wagon_by_number(number)
    wagons.find { |wagon| wagon.number == number }
  end

  protected

  def validate!
    raise "Нельзя создать поезд базового класса Train" if self.class == Train

    raise "Неподдерживаемый тип поезда" unless ALLOWED_TYPES.include?(type)

    raise "Номер должен быть текстовой строкой" unless number.class == String

    raise "Номер имеет некорректный формат" unless number =~ NUMBER_FORMAR

    raise "Скорость не может быть отрицательным значением" if speed < 0

    raise "Некорректное значение производителя поезда" unless manufacturer_title.class == String && manufacturer_title.length > 0
  end

  private

  attr_reader :wagons

  attr_writer :speed, :route, :current_station

  def pick_up_speed!(speed)
    self.speed = speed
  end

  def stay!
    self.speed = 0
  end
end
