require_relative '../../../common/inout'
require_relative '../../../common/flow'
require_relative 'abstract_file_exporter'

require 'json'

module JsonExporter
  extend self, Flow, AbstractFileExporter

  @file_extension = 'json'

  def write(file, list)
    file.write JSON.dump list
  end

end
