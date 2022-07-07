module IsValid
  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
