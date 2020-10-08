require_relative 'common/inout'

def random_tip
  tip1 = <<~TIP1
    Whenever you are offered to input multiple values, you can enter -1 to select all items from the list.
    This feature is sort of hidden because it can be very dangerous.
    Treat with caution or you might accidentally delete 99 groceries with a single press of the enter key.
  TIP1
  tip2 = <<~TIP2
    Pay attention to the text colour to know where you are:
    Cyan represents menus, Yellow usage information, Blue selectable items for your input and so on
  TIP2
  tip3 = <<~TIP3
    Each sub menu is accessible directly from the main menu. There are no sub sub menus. 
    Each menu has a unique name written above the menu entries.
    The last entry in each menu gets you back to the previous menu.
  TIP3
  tip4 = <<~TIP4
    The functionalities accessible from sub menus are called Flows. They allow you to do powerful stuff,
    such as creating, viewing, linking, renaming or deleting things. Flows have a fixed path (thus the name).
  TIP4
  tip5 = <<~TIP5
    Some Flows allow you to do multiple things. A Review Flow will usually allow you to view, delete or rename things.
    The best way to skip ahead if you don't want to do something is usually to hit 'enter'.
  TIP5
  tip6 = <<~TIP6
    Tips are useful information and will allow you to better acquaint yourself with GroceRYnoceroS.
    You should really try to see them all. The best way to do that is to use GroceRYnoceros frequently. =)
  TIP6
  tip7 = <<~TIP7
    You can create hundreds of Groceries and other stuff.
    For usability purpose listed items are often limited to 99 entries or less.
    Thus it is a good idea to make use of filters to find stuff that is not listed in the first 99 entries.
  TIP7
  tip8 = <<~TIP8
    GroceRYnoceroS stores all data in a Sqlite database file.
    If you are brave you can view and manipulate that file directly using a Sqlite Browser.
  TIP8
  tips = [tip1, tip2, tip3, tip4, tip5, tip6, tip7, tip8]
  "\tTip of the Day:\n\n#{tips[rand(tips.length)]}"
end

def print_banner
  print_banner_text <<~BANNER
                             *@@@@%.                                                                                        
                             #@/@% (@@,                  ,                                                                  
                            (@@  (@@ /@%            .%@@@@@&                                                                
                           @@. @@@*@@ ,@#       &@@@.  .@@ @@                                                               
                          /@/   *@@@@ ,@@@@@@@@@@       &@.#@/                                                              
              /*           @@,  *     %#                @@ /@(                                                              
           ,@@(&@,       .@@%                     @@@%&@@. @@                                                               
         .@@   @@       @@.                          ,@& ,@@@@.                                                             
        ,@@   @@       @@                                     %@@.                                                          
       .@@    @@.     ,@#           #/#@@@/               @@    *@@              .(&@@@@@@@@@@@@&,                          
       &@.    ,@@/@@&&@&                                  #@/    &@@@@@/ ,#@@@@@@(.    /&@@@@@@@@@@@@@@@@@@%                
       @@@@@@@/                                            &@/         .            ,@&                     *@@@#           
       @@                        /@@@  &%                   .@@                                                 *@@(        
       @@ #*  .%@@               /@@@@@@#                     @@,                                                  @@%      
       @@  .,,,                                                &@                                                   *@@,    
      @@                                                       *@#                                                   ,@@.   
      @@                 @@                                     &,                                                    ,@@   
      #@%                %@@@@                                 @/                                                      &@.  
        @@&  #@@@@@@@@@@#.                                  .@@(                                                       /@%  
          .@@@@.                                         *@@@                                                          ,@@  
               &@@@,                                .%@@@/                                                              @@  
                   *@@@@@&#/*.            .,/#&@@@@@/                                                                 @@@%  
                             .,*/@&//////,,.                  #                                                       @@@.  
                                 /@@                        @@&                                                       @@    
                                   &@&                    &@@                                            *@%         .@@    
                                   (@@@@.               #@&                                           @@%           @@/ @@
    
            .---. .----.  .----.  .---. .----..----..-.  .-..-..-. .-. .----.  .---. .----..----.  .----.  .----.         
            /   __}| {}  }/  {}  \\/  ___}| {_  | {}  }\\ \\/ / | ||  `| |/  {}  \\/  ___}| {_  | {}  }/  {}  \\{ {__          
            \\  {_ }| .-. \\\\      /\\     }| {__ | .-. \\ }  {  | || |\\  |\\      /\\     }| {__ | .-. \\\\      /.-._} }        
             `---' `-' `-' `----'  `---' `----'`-' `-' `--'  `-'`-' `-' `----'  `---' `----'`-' `-' `----' `----'         
    
    #{random_tip}
  BANNER
end

def print_bye_bye
  print_banner_text <<~BYEBYE
    
     /))_         _             _            
    /   .\\/)     |_) | | \\_/   |_) | | \\_/ | 
      \\___/      |_) |_|  |    |_) |_|  |  o
    
  BYEBYE
end

require_relative 'common/database/database'
require_relative 'common/inout'
require_relative 'schema/schema_updater'
require_relative 'subroutines/main'

print_banner
db = Database.new
db.connect
SchemaUpdater.update_schema db
Main.enter nil, db
db.disconnect
print_bye_bye
