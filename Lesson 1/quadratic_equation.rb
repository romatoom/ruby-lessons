puts "Введите коэффициент a"
a = gets.chomp.to_i

puts "Введите коэффициент b"
b = gets.chomp.to_i

puts "Введите коэффициент c"
c = gets.chomp.to_i

d = b**2 - 4 * a * c

puts "Дискриминант равен #{d}"

if d < 0
  puts "Корней нет"
elsif d == 0
  x = -b / (2 * a)
  puts "Корень равен #{x}"
else
  x1 = (-b - Math.sqrt(d)) / (2 * a)
  x2 = (-b + Math.sqrt(d)) / (2 * a)
  puts "Первый корень равен #{x1}"
  puts "Второй корень равен #{x2}"
end