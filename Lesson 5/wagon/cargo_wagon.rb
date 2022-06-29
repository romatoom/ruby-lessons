class CargoWagon < Wagon
  def initialize(manufacturer_title = "Производитель грузового поезда не указан")
    super(manufacturer_title)
    @type = :cargo
  end
end
