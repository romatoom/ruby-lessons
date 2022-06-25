=begin
  Класс Station (Станция):
  Имеет название, которое указывается при ее создании
  Может принимать поезда (по одному за раз)
  Может возвращать список всех поездов на станции, находящиеся в текущий момент
  Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
=end

class Station
  attr_reader :train_list
  attr_reader :title

  def initialize(title)
    @title = title
    @train_list = []
  end

  # принять поезд
  def take_train(train)
    @train_list << train
  end

  # отправить поезд
  def send_train(train)
    @train_list.delete(train)
  end

  # возвратить список поездов на станции по типу
  def train_list_by_type(type)
    @train_list.select { |train| train.type.downcase == type.downcase }
  end
end

