require_relative "modules/instance_counter"

class Station
  include InstanceCounter

  @@stations = []

  def self.all
    @@stations
  end

  attr_reader :train_list
  attr_reader :title

  def initialize(title)
    @title = title
    @train_list = []
    @@stations << self
    register_instance
  end

  def take_train(train)
    train_list << train
  end

  def send_train(train)
    train_list.delete(train)
  end

  def train_list_by_type(type)
    train_list.select { |train| train.type.downcase == type.downcase }
  end
end

