class List
  attr_reader :id, :name, :shops

  def initialize(id, name, shops)
    @id = id
    @name = name
    @shops = shops
  end
end

class ListShop
  attr_reader :name, :sections

  def initialize(name, sections)
    @name = name
    @sections = sections
  end
end

class ListShopSection
  attr_reader :name, :items

  def initialize(name, items)
    @name = name
    @items = items
  end
end

class ListShopSectionItem
  attr_reader :id, :name, :index

  def initialize(id, name, index)
    @id = id
    @name = name
    @index = index
  end
end
