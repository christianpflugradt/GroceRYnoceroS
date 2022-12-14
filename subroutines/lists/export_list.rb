require_relative 'exporters/clipboard_exporter'
require_relative 'exporters/html_exporter'
require_relative 'exporters/json_exporter'
require_relative 'exporters/terminal_exporter'
require_relative 'exporters/text_exporter'
require_relative '../../common/list/models'
require_relative '../../common/inout'

module ExportList
  extend self, Menu

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

  (1) Clipboard
  (2) Terminal
  (3) Text File
  (4) HTML File
  (5) [tbd] PDF File
  (6) [tbd] XML File
  (7) JSON File
  (8) Return to previous menu

  ------------------------------------------------------------------------------------

MENU

  def export_clipboard(db)
    ClipboardExporter.enter self, db
  end

  def export_terminal(db)
    TerminalExporter.enter self, db
  end

  def export_text(db)
    TextExporter.enter self, db
  end

  def export_html(db)
    HtmlExporter.enter self, db
  end

  def export_pdf(db)
    stdout 'not yet implemented :('
  end

  def export_xml(db)
    stdout 'not yet implemented :('
  end

  def export_json(db)
    JsonExporter.enter self, db
  end

end
