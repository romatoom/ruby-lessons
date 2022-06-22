=begin
  Сумма покупок.

  Пользователь вводит поочередно название товара, цену за единицу и кол-во купленного товара (может быть нецелым числом).
  Пользователь может ввести произвольное кол-во товаров до тех пор, пока не введет "стоп" в качестве названия товара.

  На основе введенных данных требуетеся:
  Заполнить и вывести на экран хеш, ключами которого являются названия товаров, а значением - вложенный хеш,
  содержащий цену за единицу товара и кол-во купленного товара. Также вывести итоговую сумму за каждый товар.

  Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".
=end

purchases = Hash.new

=begin

# sample purchases

purchases = {
  "title1" => {
    unit_price: 10.0,
    amount: 2.0
  },

  "title2" => {
    unit_price: 1.5,
    amount: 10.0
  },

  "title3" => {
    unit_price: 500,
    amount: 0.5
  }
}

=end

loop do
  puts "Введите название товара (или слово 'стоп', чтобы завершить покупку)"
  title = gets.chomp
  break if title.downcase == "стоп"

  puts "Введите цену за единицу"
  unit_price = gets.chomp.to_f

  puts "Введите количество купленного товара"
  amount = gets.chomp.to_f

  purchases[title] = {
    unit_price: unit_price,
    amount: amount
  }
end

sum = 0

purchases.each do |k, v|
  purchase_price = v[:amount] * v[:unit_price]

  puts "Куплено #{v[:amount]} товаров \"#{k}\" на сумму #{purchase_price}"

  sum += purchase_price
end

puts "Итоговая сумма всех покупок: #{sum}"
