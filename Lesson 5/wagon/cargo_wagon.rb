class CargoWagon < Wagon
  attr_reader :total_volume, :taked_volume

  def initialize(total_volume, manufacturer_title = "Производитель грузового поезда не указан")
    manufacturer_title ||= "Производитель грузового поезда не указан"
    super(:cargo, manufacturer_title)

    @total_volume = total_volume
    @taked_volume = 0.0
  end

  def take_a_volume(volume)
    return take_a_volume!(volume) if available_volume >= volume

    raise "Вы пытаетесь занять объём, превышающий допустимое количество"
  end

  def available_volume
    total_volume - taked_volume
  end

  protected

  attr_writer :taked_volume

  def take_a_volume!(volume)
    self.taked_volume += volume
  end
end
