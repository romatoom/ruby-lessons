class PassengerWagon < Wagon
  attr_reader :number_of_seats, :number_of_taked_seats

  def initialize(number_of_seats, manufacturer_title = "Производитель пассажирского вагона не указан")
    super(:passenger, manufacturer_title)

    @number_of_seats = number_of_seats
    @number_of_taked_seats = 0
  end

  def take_a_seat
    return take_a_seat! if number_of_empty_seats > 0

    raise "Вы пытаетесь занять число мест, превышающее допустимое количество"
  end

  def number_of_empty_seats
    number_of_seats - number_of_taked_seats
  end

  protected

  attr_writer :number_of_taked_seats

  def take_a_seat!
    self.number_of_taked_seats += 1
  end
end
