require_relative '../../../common/inout'
require_relative '../../../common/flow'
require_relative 'base_exporter'

module TerminalExporter
  extend self, Flow, BaseExporter

  @hint_exp = <<HINT_EXP

  -------------
  [Export List]
    
  GroceRYnoceroS exported the shopping list to stdout.
  You can find it above this info text.

  Press enter to return to the previous menu.
  -------------------------------------------------------------

HINT_EXP

  def write(list_id, lines)
    stdout ">>> shopping list #{list_id} below <<<"
    stdout lines.join "\n"
    print_usage_text @hint_exp
  end

end
