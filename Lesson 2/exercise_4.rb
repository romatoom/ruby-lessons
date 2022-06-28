# Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).

letters = ['а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я']

vowels = ['а', 'я', 'у', 'ю', 'о', 'е', 'ё', 'э', 'и', 'ы']

hash = Hash.new

vowels.each { |let| hash[let] = letters.find_index(let) + 1 }

hash = hash.sort_by { |k, v| v }

hash.each { |k, v| puts "#{k} - #{v}" }