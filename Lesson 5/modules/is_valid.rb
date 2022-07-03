module IsValid
  def valid?
    validate!
    true
  rescue
    false
  end
end
