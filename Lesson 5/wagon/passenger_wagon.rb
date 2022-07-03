class PassengerWagon < Wagon
  def initialize(manufacturer_title = "Производитель пассажирского вагона не указан")
    super(:passenger, manufacturer_title)
  end
end
