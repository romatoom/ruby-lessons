class CargoTrain < Train
  def initialize(number)
    super(number)

    @type = :cargo
  end

  def max_speed
    90
  end
end
