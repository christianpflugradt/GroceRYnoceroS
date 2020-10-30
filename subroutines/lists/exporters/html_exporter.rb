require_relative '../../../common/flow'
require_relative 'abstract_file_exporter'

require 'os'

module HtmlExporter
  extend self, Flow, AbstractFileExporter

  @file_extension = 'html'

  def write(file, list)
    file.write "<html><head><title>#{list.id} - #{list.name}</title><body>"
    list.shops.each do |shop|
      file.write "<h1>#{shop.name}</h1>" if list.shops.length.positive?
      shop.sections.each { |section| write_section file, section }
    end
  end

  def write_section(file, section)
    file.write "<h2>#{section.name}</h2>"
    section.items.each do |item|
      file.write "<input type=\"checkbox\" id=\"#{item.id}\"><label for=\"#{item.id}\">#{item.name}</label><br>"
    end
  end

end
