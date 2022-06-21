puts "Введите длину первой стороны треугольника"
side1 = gets.chomp.to_f

puts "Теперь длину второй стороны"
side2 = gets.chomp.to_f

puts "И, наконец третьей"
side3 = gets.chomp.to_f

# равносторонний
is_equilateral = (side1 == side2) && (side2 == side3)

# равнобедренный
is_isosceles = (side1 == side2) || (side2 == side3) || (side1 == side3)

# прямоугольный
if !is_equilateral
  longest_side = [side1, side2, side3].max

  if longest_side == side1
    is_rectangular = side1**2 == side2**2 + side3**2
  elsif longest_side == side2
    is_rectangular = side2**2 == side1**2 + side3**2
  else
    is_rectangular = side3**2 == side1**2 + side2**2
  end
end

if is_equilateral
  puts "Треугольник равносторонний и равнобедренный"
elsif is_isosceles && is_rectangular
  # ввиду ошибки в точности вычислений для чисел с плавающей точкой
  # в рамках этой программы этот вариант маловероятен
  puts "Треугольник равнобедренный и прямоугольный"
elsif is_isosceles
  puts "Треугольник равнобедренный"
elsif is_rectangular
  puts "Треугольник прямоугольный"
else
  puts "Обычный треугольник"
end
