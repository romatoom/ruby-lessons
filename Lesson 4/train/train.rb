class Train
  attr_reader :speed
  attr_reader :type
  attr_reader :number
  attr_reader :route
  attr_reader :current_station

  def initialize(number)
    @number = number
    @type = nil
    @speed = 0
    @current_station = nil
    @wagons = []
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
    # поезд едет до станции назначения
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
    # поезд едет до станции назначения
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

  # поезд может набирать скорость не только, когда отправляется от станции (в пути скорость может меняться), поэтому в public
  def pick_up_speed(speed)
    pick_up_speed!(speed) if speed <= max_speed
  end

  # поезд может тормозить не только, когда прибывает на станцию (в пути могут возникнуть ситуации, когда нужно остановиться), поэтому в public
  def stay
    stay! if speed > 0
  end

  # в рамках текущей реализации не предполагаем, что методы, будут меняться в потомках, поэтому private
  private

  # скрываем доступ к чтению непосредственно аттрибута вагонов вне класса
  attr_reader :wagons

  # скрываем доступ к изменению скорости вне класса
  attr_writer :speed

  # скрываем доступ к изменению маршрута поезда вне класса
  attr_writer :route

  # скрываем доступ к изменению текущей станции вне класса
  attr_writer :current_station

  # скрываем внутреннюю реализацию набора скорости
  def pick_up_speed!(speed)
    self.speed = speed
  end

  # скрываем внутреннюю реализацию сброса скорости
  def stay!
    self.speed = 0
  end
end
