puts "Введите ваше имя"
name = gets.chomp

puts "Введите ваш рост в сантиметрах"
height = gets.chomp.to_i

ideal_weight = (height - 110) * 1.15

if ideal_weight >= 0
  puts "#{name}, ваш идеальный вес должен быть #{ideal_weight.round(2)} кг."
else
  puts "Ваш вес уже оптимальный"
end