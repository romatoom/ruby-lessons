require_relative "accessors"

module Manufacturer
  extend Accessors
  attr_accessor_with_history :manufacturer_title, :manufacturer_address
end
