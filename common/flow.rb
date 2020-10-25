module Flow

  class Item
    attr_reader :id, :name, :index

    def initialize(id, name, index)
      @id = id
      @name = name
      @index = index
    end
  end

  def enter(caller, db)
    run db
    caller&.print_menu
  end

  def find_by_index(id, list)
    list.find { |item| item.index == id }
  end

  def print_list(list)
    print_list_header
    list.each { |item| print_list_item item.index, item.name }
  end

  def max_id(list)
    list.length
  end

end
