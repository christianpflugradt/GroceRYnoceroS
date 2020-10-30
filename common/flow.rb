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

  def filter_to_included(list, included)
    list = list.filter do |item|
      included.include? item.id
    end
    list = update_indices list
    list
  end

  def filter_to_non_included(list, included)
    list = list.filter do |item|
      !included.include? item.id
    end
    list = update_indices list
    list
  end

  def update_indices(list)
    list.each_with_index do |item, index|
      item.index = index + 1
    end
  end

  # converts a 'sql_result' into 'clazz' instances and puts them into a 'list'
  # === usage and purpose ===
  # this function is meant to be used for items displayed to the user during a Flow
  # an item consists of id, name and index
  # - id is the primary key for that entity in the database
  # - index is the position the item displayed to the user starting with 1
  # - name is the name of the item displayed to the user
  # the sql_result must return the id in the first column and the name in the second column
  # the clazz must take the id as the first constructor argument, the name second and the index last
  # the index value is automatically calculated in this function
  def load_items(sql_result, list, clazz)
    list.clear
    begin
      sql_result.each_with_index do |row, index|
        list.append clazz.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

end
