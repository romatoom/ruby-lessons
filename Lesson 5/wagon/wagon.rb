require_relative "../modules/manufacturer"
require_relative "../modules/is_valid"

class Wagon
  include Manufacturer

  include IsValid

  ALLOWED_TYPES = [:cargo, :passenger]

  attr_reader :type

  def initialize(type, manufacturer_title)
    @type = type
    @manufacturer_title = manufacturer_title

    validate!
  end

  protected

  def validate!
    raise "Нельзя создать вагон базового класса Wagon" if self.class == Wagon

    raise "Название вагона должно быть текстовой строкой" unless manufacturer_title.class == String

    raise "Название вагона не должно быть пустой строкой" if manufacturer_title == ""

    raise "Неподдерживаемый тип вагона" unless ALLOWED_TYPES.include?(type)
  end
end
