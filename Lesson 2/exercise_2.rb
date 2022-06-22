# Заполнить массив числами от 10 до 100 с шагом 5

arr = []

current = 10
finish = 100
step = 5

while current <= finish do
  arr << current
  current += step
end

puts arr
