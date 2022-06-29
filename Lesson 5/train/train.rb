require_relative "../modules/manufacturer"
require_relative "../modules/instance_counter"

class Train
  include InstanceCounter

  include Manufacturer

  @@trains = []

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  attr_reader :speed, :type, :number, :route, :current_station

  def initialize(number)
    @number = number
    @type = nil
    @speed = 0
    @current_station = nil
    @wagons = []
    @@trains << self
    register_instance
    set_manufacturer_title "Производитель не указан"
  end

  def max_speed
    0
  end

  def wagons_count
    wagons.length
  end

  def attach_wagon(wagon)
    wagons << wagon if (speed == 0) && (wagon.type == type)
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
