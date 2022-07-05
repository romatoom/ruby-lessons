require_relative "modules/instance_counter"
require_relative "modules/is_valid"

class Station
  include InstanceCounter

  include IsValid

  @@all = []

  class << self
    def lambda_print_trains
      ->(train) { puts "#{train.number}, #{train.type}, #{train.wagons_count}" }
    end

    def all
      @@all
    end
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

  def print_train_list
    each_trains(&Station.lambda_print_trains)
  end

  def each_trains(&block)
    return until block_given?

    train_list.each { |train| block.call(train) }
  end

  private

  def validate!
    raise "Название станции должно быть текстовой строкой" unless title.class == String

    raise "Название станции не должно быть пустой строкой" if title == ""
  end
end

