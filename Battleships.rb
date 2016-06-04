require "ncursesw"
# require "./common"
require "./board"
include Ncurses

begin
  scr = Ncurses.initscr()
  Ncurses.cbreak()
  Ncurses.noecho()
  playerBoard=Board.new(0,0)
  enemyBoard=Board.new(0,42)
  scr.refresh()
  playerBoard.drawBoard()
  enemyBoard.drawBoard()

  # board=WINDOW.new(Common::M_HEIGHT,Common::M_WIDTH,0,0)
  # board.box(0,0)
  Ncurses.keypad(scr, true)
  # board.wrefresh()
  scr.wgetch();





ensure
Ncurses.endwin();

end
