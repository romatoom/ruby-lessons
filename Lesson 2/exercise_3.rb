# Заполнить массив числами Фибоначчи до 100

arr = [0, 1]

сurr_index = 2

finish = 100

loop do
  next_element = arr[сurr_index - 2] + arr[сurr_index - 1]

  break if next_element >= finish

  arr << next_element

  сurr_index += 1
end

puts arr
