require_relative 'models'
require_relative 'loader'
require_relative 'text_exporter'
require_relative '../inout'


module Exporter
  extend self, Menu

  attr_writer :list_id

  @list_id = nil

  @subroutines = %i[
    export_clipboard
    export_terminal
    export_text
    export_html
    export_pdf
    export_xml
    export_json
  ]

  @menu = <<MENU

  ----------------
  [Export List]

  Choose one of the below options to export your shopping list.
  You will be returned to this menu after each export.

  To return to the previous menu choose the last option.

  (1) [TBD] Clipboard
  (2) [TBD] Terminal
  (3) Text File
  (4) [TBD] HTML File
  (5) [TBD] PDF File
  (6) [TBD] XML File
  (7) [TBD] JSON File
  (8) Return to previous menu

  ------------------------------------------------------------------------------------

MENU

  def export_clipboard(db)
    stdout 'not yet implemented :('
  end

  def export_terminal(db)
    stdout 'not yet implemented :('
  end

  def export_text(db)
    TextExporter.run Loader.load_list db, @list_id
  end

  def export_html(db)
    stdout 'not yet implemented :('
  end

  def export_pdf(db)
    stdout 'not yet implemented :('
  end

  def export_xml(db)
    stdout 'not yet implemented :('
  end

  def export_json(db)
    stdout 'not yet implemented :('
  end

end
