module InteractionHelper
  private

  def menus
    {
      main_menu: {
        title: "Главное меню",
        items: {
          0 => {
            command: :stop,
            text: "Завершить работу"
          },

          1 => {
            command: :menu_control,
            param: :manage_stations_menu,
            text: "Управление станциями"
          },

          2 => {
            command: :menu_control,
            param: :manage_trains_menu,
            text: "Управление поездами"
          },

          3 => {
            command: :menu_control,
            param: :manage_routes_menu,
            text: "Управление маршрутами"
          },

          4 => {
            command: :print_info_about_trains_on_stantions,
            text: "Информация о поездах на станциях"
          }
        }
      },

      manage_stations_menu: {
        title: "Меню управления станциями",
        items: {
          0 => {
            command: :back,
            text: "Назад"
          },

          1 => {
            command: :create_station,
            text: "Создать станцию"
          },

          2 => {
            command: :print_stations_list,
            text: "Посмотреть список станций"
          },

          3 => {
            command: :print_trains_on_station,
            text: "Просмотреть список поездов на станции (детально)"
          },

          4 => {
            command: :print_trains_list_on_station,
            text: "Просмотреть список поездов на станции (общий)"
          }
        }
      },

      manage_trains_menu: {
        title: "Меню управления поездами",
        items: {
          0 => {
            command: :back,
            text: "Назад"
          },

          1 => {
            command: :create_train,
            text: "Создать поезд"
          },

          2 => {
            command: :take_route_for_train,
            text: "Назначить маршрут поезду"
          },

          3 => {
            command: :attach_wagons_to_train,
            text: "Добавить вагоны к поезду"
          },

          4 => {
            command: :unhook_wagon_from_train,
            text: "Отцепить вагоны от поезда"
          },

          5 => {
            command: :move_train_to_next_station,
            text: "Переместить поезд по маршруту вперед"
          },

          6 => {
            command: :move_train_to_previous_station,
            text: "Переместить поезд по маршруту назад"
          },

          7 => {
            command: :print_train_wagons_list,
            text: "Вывести список вагонов"
          },

          8 => {
            command: :take_wagon_volume,
            text: "Занять место в вагоне"
          }
        }
      },

      manage_routes_menu: {
        title: "Меню управления маршрутами",
        items: {
          0 => {
            command: :back,
            text: "Назад"
          },

          1 => {
            command: :create_route,
            text: "Создать маршрут"
          },

          2 => {
            command: :push_intermediate_station_to_route,
            text: "Добавить промежуточную станцию (перед конечной станцией)"
          },

          3 => {
            command: :insert_intermediate_station_to_route,
            text: "Добавить промежуточную станцию (в другое место в маршруте)"
          }
        }
      }
    }
  end

  def input_value(clarification)
    puts clarification
    print "> "

    input = gets.chomp
    puts

    input
  end

  def input_from_list(list)
    return if list.length.zero?

    loop do
      input = gets.chomp
      puts

      break if input == "cancel"

      return input if list.include?(input)

      print
      puts "Нужно ввести значение из списка: #{list.join(', ')}"
      puts "Для отмены введите команду: cancel"
      print "> "
    end
  end

  def print_command_cancel
    puts "Выполнение команды было прервано\n\n"
  end

  def print_menu(menu_key)
    puts "#{menus[menu_key][:title]}. Введите команду:"
    menus[menu_key][:items].each { |key, menu_item| puts "#{key}. #{menu_item[:text]}" }
    print "> "
  end

  def menu_control(menu_key)
    loop do
      print_menu(menu_key)

      choice = gets.chomp
      puts

      next if choice !~ /^\d+$/

      break if choice.to_i.zero?

      command_item = menus[menu_key][:items][choice.to_i]

      next if command_item.nil?

      method = command_item[:command]
      param = command_item[:param]

      param ? send(method, param) : send(method)
    end
  end
end
