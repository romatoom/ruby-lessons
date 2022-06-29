class PassengerTrain < Train
  def initialize(number)
    super(number)

    @type = :passenger
  end

  def max_speed
    120
  end
end
