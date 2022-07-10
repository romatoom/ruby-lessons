module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_history = "@#{name}_history".to_sym
      var_name = "@#{name}".to_sym

      define_method(name) do
        instance_variable_get(var_name)
      end

      define_method("#{name}=") do |value|
        if instance_variable_get(var_history).nil?
          initial_value = instance_variable_get(var_name)
          instance_variable_set(var_history, [initial_value])
        end

        history = instance_variable_get(var_history)
        history << value
        instance_variable_set(var_history, history)

        instance_variable_set(var_name, value)
      end

      define_method("#{name}_history") { instance_variable_get(var_history) }
    end
  end

  def strong_attr_accessor(name, class_name)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }

    define_method("#{name}=") do |value|
      raise "Попытка присвоить атрибуту значение другого типа" unless value.instance_of?(class_name)

      instance_variable_set(var_name, value)
    end
  end
end
