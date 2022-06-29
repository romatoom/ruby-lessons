module Manufacturer
  attr_reader :manufacturer_title

  def set_manufacturer_title(title)
    self.manufacturer_title = title
  end

  private

  attr_writer :manufacturer_title
end
