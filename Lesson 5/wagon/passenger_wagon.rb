class PassengerWagon < Wagon
  def initialize(manufacturer_title = "Производитель пассажирского вагона не указан")
    super(manufacturer_title)
    @type = :passenger
  end
end
