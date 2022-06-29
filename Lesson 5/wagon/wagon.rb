require_relative "../modules/manufacturer"

class Wagon
  include Manufacturer

  attr_reader :type

  def initialize(manufacturer_title = "Производитель не указан")
    @type = nil
    set_manufacturer_title(manufacturer_title)
  end
end
