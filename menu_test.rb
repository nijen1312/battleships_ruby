require "ncursesw"

include Ncurses
include Ncurses::Menu

begin
  scr = Ncurses.initscr()
  Ncurses.cbreak()
  Ncurses.noecho()
  #Ncurses.keypad(scr, true)
  optionsLabels=["dicdicdic","ladladlad","firfirfir"]
  options = Array.new
  options.push(ITEM.new(optionsLabels[0]," "))
  options.push(ITEM.new(optionsLabels[1]," "))
  options.push(ITEM.new(optionsLabels[2]," "))
  menu=MENU.new(options)
  # menuWindow=WINDOW.new(9,30,8,8)
  # menuWindow.box(0,0)
  Ncurses.keypad(scr, true)
  menu.set_menu_win(scr)
  menu.set_menu_sub(scr.derwin(5,25,3,5))
  menu.set_menu_format(3,1)
  menu.menu_opts_off(O_SHOWDESC)
  menu.set_menu_mark(" * ")
  menu.post_menu()
  scr.refresh()
  # menuWindow.wrefresh()
  while((ch = scr.getch()) != KEY_F1)
    case ch
    when KEY_DOWN
      # Go to next field */
      # my_form.form_driver(REQ_VALIDATION);
      menu.menu_driver(REQ_DOWN_ITEM);
      # Go to the end of the present buffer
      # Leaves nicely at the last character

    when KEY_UP
      # Go to previous field
      menu.menu_driver(REQ_UP_ITEM);
      # my_form.form_driver(REQ_VALIDATION);
      # my_form.form_driver(REQ_PREV_FIELD);
      # my_form.form_driver(REQ_END_LINE);

    end
  end

ensure
  Ncurses.echo()
  Ncurses.nocbreak()
  Ncurses.nl()
  Ncurses.endwin()
end
