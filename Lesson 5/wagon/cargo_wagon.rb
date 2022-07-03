class CargoWagon < Wagon
  def initialize(manufacturer_title = "Производитель грузового поезда не указан")
    super(:cargo, manufacturer_title)
  end
end
