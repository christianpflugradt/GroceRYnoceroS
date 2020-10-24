require_relative '../../common/inout'
require_relative '../../common/flow'
require_relative '../../common/list/list_service'

module CreateList
  extend self, Flow

  @hint_list = <<HINT_LIST

  -------------
  [Create List]

  Enter a name for the list or just press enter to generate a name programmatically.
  ----------------------------------------------------------------------------------

HINT_LIST

  def run(db)
    print_usage_text @hint_list
    ListService.id = db.create_list input 'list name'
  end

end
