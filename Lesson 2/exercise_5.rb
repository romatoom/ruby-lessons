=begin
  Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
  Найти порядковый номер даты, начиная отсчет с начала года.
  Учесть, что год может быть високосным.

  Если год не делится на 4, значит он обычный.
  Иначе надо проверить не делится ли год на 100.
  Если не делится, значит это не столетие и можно сделать вывод, что год високосный.
  Если делится на 100, значит это столетие и его следует проверить его делимость на 400.
  Если год делится на 400, то он високосный.
  Иначе год обычный.
=end

def leap_year?(year)
  if year % 4 != 0
    return false
  elsif year % 100 != 0
    return true
  else
    return year % 400 == 0
  end
end

=begin

# is a simple test of method leap_year?

require 'Date'

wrong_count = 0

for i in 1..10000 do
  wrong_count += 1 unless Date.leap?(i) == leap_year?(i)
end

abort "Не совпало #{wrong_count} значений" if wrong_count > 0

=end

puts "Введите день (число)"
day = gets.chomp.to_i

puts "Введите месяц (число)"
month = gets.chomp.to_i

puts "Введите год"
year = gets.chomp.to_i

if leap_year? year
  feb_length = 29
  year_desc = 'високосный'
else
  feb_length = 28
  year_desc = 'обычный'
end

puts "Выбрана дата: #{day}.#{month}.#{year} (#{year} - #{year_desc} год)"

months_length = [31, feb_length, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

previous_months_days = 0

for i in 1..month - 1
  previous_months_days += months_length[i - 1]
end

previous_months_days += day

puts "Порядковый номер даты (номер дня в году) равен #{previous_months_days}"
