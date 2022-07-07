require_relative "../modules/manufacturer"
require_relative "../modules/is_valid"

class Wagon
  include Manufacturer

  include IsValid

  ALLOWED_TYPES = %i[cargo passenger].freeze

  attr_reader :type

  attr_accessor :number

  def initialize(type, manufacturer_title)
    @type = type
    @manufacturer_title = manufacturer_title

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

  def validate!
    raise "Нельзя создать вагон базового класса Wagon" if instance_of?(Wagon)

    raise "Название вагона должно быть текстовой строкой" unless manufacturer_title.instance_of?(String)

    raise "Название вагона не должно быть пустой строкой" if manufacturer_title == ""

    raise "Неподдерживаемый тип вагона" unless ALLOWED_TYPES.include?(type)

    # raise "Номер вагона должен быть положительным целым числом" unless number.class == Fixnum && number > 0
  end
end
