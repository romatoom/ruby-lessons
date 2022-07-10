module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate_rules
      @validate_rules ||= []
    end

    def validate(attr_name, validation_type, validation_param = nil)
      validate_rules << {
        attr_name: attr_name,
        validation_type: validation_type,
        validation_param: validation_param
      }
    end

    protected

    attr_writer :validate_rules
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    protected

    def validate!
      class_name = self.class
      class_name = Train if [CargoTrain, PassengerTrain].include? class_name
      class_name = Wagon if [CargoWagon, PassengerWagon].include? class_name

      class_name.validate_rules.each do |validate_rule|
        attr_name_var_value = instance_variable_get("@#{validate_rule[:attr_name]}".to_sym)

        validate_checks = {
          presence: :presence_check,
          format: :format_check,
          type: :type_check
        }

        validation_type = validate_rule[:validation_type]

        send(validate_checks[validation_type], attr_name_var_value, validate_rule)
      end

      additional_validate! if :additional_validate!.nil?
    end

    def presence_check(attr_name_var_value, validate_rule)
      raise "Атрибут #{validate_rule[:attr_name]} должен быть не nil и не пустой строкой" if attr_name_var_value.nil? || attr_name_var_value == ""
    end

    def format_check(attr_name_var_value, validate_rule)
      return if attr_name_var_value =~ validate_rule[:validation_param]

      raise "Атрибут #{validate_rule[:attr_name]} не соответсвует формату #{validate_rule[:validation_param].source}"
    end

    def type_check(attr_name_var_value, validate_rule)
      return if attr_name_var_value.instance_of?(validate_rule[:validation_param])

      raise "Атрибут #{validate_rule[:attr_name]} должен иметь класс #{validate_rule[:validation_param]}"
    end
  end
end
