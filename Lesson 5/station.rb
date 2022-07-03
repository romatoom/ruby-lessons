require_relative "modules/instance_counter"
require_relative "modules/is_valid"

class Station
  include InstanceCounter

  include IsValid

  @@all = []

  def self.all
    @@all
  end

  attr_reader :train_list
  attr_reader :title

  def initialize(title)
    @title = title
    @train_list = []

    validate!

    @@all << self
    register_instance
  end

  def take_train(train)
    raise "Аргумент должен быть поездом" unless train.class.ancestors.include?(Train) && train.valid?

    train_list << train
  end

  def send_train(train)
    train_list.delete(train)
  end

  def train_list_by_type(type)
    train_list.select { |train| train.type.downcase == type.downcase }
  end

  private

  def validate!
    raise "Название станции должно быть текстовой строкой" unless title.class == String

    raise "Название станции не должно быть пустой строкой" if title == ""
  end
end

