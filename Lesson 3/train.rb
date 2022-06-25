=begin
  Класс Train (Поезд):
  Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
  Может набирать скорость
  Может возвращать текущую скорость
  Может тормозить (сбрасывать скорость до нуля)
  Может возвращать количество вагонов
  Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
  Может принимать маршрут следования (объект класса Route).
  При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
  Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
  Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
=end

class Train
  attr_reader :speed
  attr_reader :max_speed
  attr_reader :wagons_count
  attr_reader :type
  attr_reader :number

  attr_accessor :current_station

  def initialize(number, type, wagons_count)
    @number = number
    @type = type
    @wagons_count = wagons_count
    @speed = 0
    @max_speed = 100
    @current_station = nil
  end

  # набрать скорость
  def pick_up_speed(speed)
    @speed = speed
  end

  # затормозить
  def stay
    @speed = 0
  end

  # прицепить вагон
  def attach_wagon
    @wagons_count += 1 if speed == 0
  end

  # отцепить вагон
  def unhook_wagon
    @wagons_count -= 1 if (speed == 0) && (wagons_count > 0)
  end

  # принять маршрут следования
  def take_route(route)
    @route = route

    # При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
    @route.start_station.take_train(self)
    @current_station = @route.start_station
  end

  # переместиться к следующей станции
  def move_to_next_station
    return if next_station.nil?
    destination = next_station

    @current_station.send_train(self)
    @current_station = nil

    pick_up_speed(max_speed)
    # поезд едет до станции назначения
    stay

    @current_station = destination
    @current_station.take_train(self)
  end

  # переместиться к предыдущей станции
  def move_to_previous_station
    return if previous_station.nil?
    destination = previous_station

    @current_station.send_train(self)
    @current_station = nil

    pick_up_speed(max_speed)
    # поезд едет до станции назначения
    stay

    @current_station = destination
    @current_station.take_train(self)
  end

  # узнать предыдущую станцию
  def previous_station
    index = @route.all_stations.find_index(@current_station)

    if index > 0
      @route.all_stations[index - 1]
    else
      nil
    end
  end

  # узнать следующую станцию
  def next_station
    index = @route.all_stations.find_index(@current_station)

    if index < @route.all_stations.length - 1
      @route.all_stations[index + 1]
    else
      nil
    end
  end
end
