=begin
module MyAttrAccessor
  def my_attr_accessor(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) { |value| instance_variable_set(var_name, value) }
    end
  end
end

class Test
  extend MyAttrAccessor

  my_attr_accessor :my_attr, :my_attr_2, :my_attr_3
end

t = Test.new
t.my_attr = 5
t.my_attr_2 = 5
t.my_attr_3 = 5

puts t.instance_variables
=end

class X
  def method_missing(name, *args)
    self.class.send(:define_method, name.to_sym, lambda { |*args| puts "args: #{args.inspect}" })
    send(name.to_sym, *args)
  end
end

x = X.new
p x.public_methods
p x.abc 1, 2, 3

p x.abc 2, 3, 4
