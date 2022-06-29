module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :instances

    def increment_instances
      self.instances ||= 0
      self.instances += 1
    end

    private

    attr_writer :instances
  end

  module InstanceMethods
    private

    def register_instance
      self.class.increment_instances
    end
  end
end