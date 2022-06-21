puts "Введите длину основания треугольника"
base = gets.chomp.to_f

puts "Введите высоту треугольника"
height = gets.chomp.to_f

triangle_square = base * height / 2

puts "Площадь треугольника равна #{triangle_square}"
