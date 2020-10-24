class List
  attr_reader :id, :name, :sections

  def initialize(id, name, sections)
    @id = id
    @name = name
    @sections = sections
  end
end

class ListSection
  attr_reader :name, :items

  def initialize(name, items)
    @name = name
    @items = items
  end
end

class ListSectionItem
  attr_reader :id, :name, :index

  def initialize(id, name, index)
    @id = id
    @name = name
    @index = index
  end
end
