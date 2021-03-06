require_relative "../modules/manufacturer"
require_relative "../modules/instance_counter"
require_relative "../modules/validation"

class Train
  include InstanceCounter

  include Manufacturer

  include Validation

  NUMBER_FORMAT = /^[а-яa-z\d]{3}-?[а-яa-z\d]{2}$/i.freeze

  ALLOWED_TYPES = %i[cargo passenger].freeze

  @all = []

  validate :number, :presence
  validate :number, :type, String
  validate :number, :format, NUMBER_FORMAT

  validate :speed, :type, Float

  validate :manufacturer_title, :presence
  validate :manufacturer_title, :type, String

  validate :manufacturer_address, :presence
  validate :manufacturer_address, :type, String

  class << self
    attr_reader :all

    def lambda_print_train
      ->(train) { puts "#{train.number}, #{train.type}, #{train.wagons_count}" }
    end

    def find(number)
      all.find { |train| train.number == number }
    end

    def allowed_types
      ALLOWED_TYPES
    end
  end

  attr_reader :speed, :type, :number, :route, :current_station

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0.0
    @current_station = nil
    @route = nil
    @wagons = []
    @manufacturer_title = "Производитель не указан"
    @manufacturer_address = "Адрес производителя не указан"

    validate!

    Train.all << self
    register_instance
  end

  def wagons_count
    wagons.length
  end

  def attach_wagon(wagon)
    raise "Аргумент должен быть вагоном" unless wagon.class.ancestors.include?(Wagon) && wagon.valid?

    wagon.number = wagons_count + 1

    wagons << wagon if speed.zero? && wagon.type == type
  end

  def unhook_wagon
    wagons.pop if speed.zero? && wagons_count.positive?
  end

  def print_wagons_manufacturers
    manufacturers_counts = Hash.new(0)

    wagons.each { |wagon| manufacturers_counts[wagon.manufacturer_title] += 1 }

    puts "Производители вагонов поезда c номером #{number}:"

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
    if route.nil?
      "Маршрут не назначен"
    else
      "#{route.start_station.title} - #{route.finish_station.title}"
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

    route.stations_list[index - 1] if index.positive?
  end

  def next_station
    index = route.stations_list.find_index(current_station)

    route.stations_list[index + 1] if index < route.stations_list.length - 1
  end

  def pick_up_speed(speed)
    pick_up_speed!(speed) if speed <= max_speed
  end

  def stay
    stay! if speed.positive?
  end

  def each_wagons(&block)
    return unless block_given?

    wagons.each { |wagon| block.call(wagon) }
  end

  def print_wagons_list
    return puts "К поезду не прицеплено ни одного вагона\n\n" if wagons_count.zero?

    each_wagons(&Wagon.lambda_print_wagon)
    puts
  end

  def find_wagon_by_number(number)
    wagons.find { |wagon| wagon.number == number }
  end

  def additional_validate!
    raise "Нельзя создать поезд базового класса Train" if instance_of?(Train)
    raise "Неподдерживаемый тип поезда" unless ALLOWED_TYPES.include?(type)
    raise "Скорость не может быть отрицательным значением" if speed.negative?
  end

  private

  attr_reader :wagons

  attr_writer :speed, :route, :current_station

  def pick_up_speed!(speed)
    self.speed = speed
  end

  def stay!
    self.speed = 0.0
  end
end
