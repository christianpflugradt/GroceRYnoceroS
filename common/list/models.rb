class List
  attr_reader :id, :name, :shops

  def initialize(id, name, shops)
    @id = id
    @name = name
    @shops = shops
  end

  def to_json(*opts)
    {
      id: @id,
      name: @name,
      shops: @shops
    }.to_json(*opts)
  end

end

class ListShop
  attr_reader :name, :sections

  def initialize(name, sections)
    @name = name
    @sections = sections
  end

  def to_json(*opts)
    {
      name: @name,
      sections: @sections
    }.to_json(*opts)
  end

end

class ListShopSection
  attr_reader :name, :items

  def initialize(name, items)
    @name = name
    @items = items
  end

  def to_json(*opts)
    {
      name: @name,
      items: @items
    }.to_json(*opts)
  end

end

class ListShopSectionItem
  attr_reader :id, :name, :index

  def initialize(id, name, index)
    @id = id
    @name = name
    @index = index
  end

  def to_json(*opts)
    {
      id: @id,
      name: @name,
      index: @index
    }.to_json(*opts)
  end

end
