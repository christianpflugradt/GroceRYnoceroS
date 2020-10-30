require_relative '../../../common/inout'
require_relative '../../../common/flow'
require_relative 'abstract_plain_exporter'

require 'clipboard'

module ClipboardExporter
  extend self, Flow, AbstractPlainExporter

  @hint_exp = <<HINT_EXP

  -------------
  [Export List]
    
  GroceRYnoceroS exported the shopping list to clipboard.
  You can usually access clipboard by pressing Ctrl+V (Windows/Linux) or Cmd+V (Mac).

  Press enter to return to the previous menu.
  -------------------------------------------------------------

HINT_EXP

  def write(list_id, lines)
    Clipboard.copy lines.join "\n"
    print_usage_text @hint_exp
  end

end
