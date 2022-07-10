require_relative "../modules/manufacturer"
require_relative "../modules/validation"
require_relative "../modules/accessors"

class Wagon
  include Manufacturer

  include Validation

  extend Accessors

  ALLOWED_TYPES = %i[cargo passenger].freeze

  attr_reader :type

  strong_attr_accessor :number, Integer

  validate :number, :type, Integer

  def initialize(type, manufacturer_title)
    @type = type
    @manufacturer_title = manufacturer_title
    @number = 0

    validate!
  end

  def self.lambda_print_wagon
    lambda do |wagon|
      free_value = wagon.type == :passenger ? wagon.number_of_empty_seats : wagon.available_volume
      taked_value = wagon.type == :passenger ? wagon.number_of_taked_seats : wagon.taked_volume

      puts "#{wagon.number}, #{wagon.type}, #{free_value}, #{taked_value}"
    end
  end

  protected

  def additional_validate!
    raise "Нельзя создать вагон базового класса Wagon" if instance_of?(Wagon)
    raise "Неподдерживаемый тип вагона" unless ALLOWED_TYPES.include?(type)
  end
end
