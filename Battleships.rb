require "ncursesw"
# require "./common"
require "./board"
require "./fleet"
include Ncurses

begin
  scr = Ncurses.initscr()
  Ncurses.cbreak()
  Ncurses.noecho()
  Ncurses.keypad(scr, true)
  playerBoard=Board.new(0,0)
  playerFleet=Fleet.new(4,playerBoard)
  enemyBoard=Board.new(0,42)
  enemyFleet=Fleet.new(4,enemyBoard)
  playerFleet.initializeFleet(false)
  enemyFleet.initializeFleet(true)
  scr.refresh()
  enemyBoard.drawBoard()
  scr.refresh()
  playerBoard.drawBoard()
  playerFleet.deployFleet()
  # board=WINDOW.new(Common::M_HEIGHT,Common::M_WIDTH,0,0)
  # board.box(0,0)
  # board.wrefresh()
  # scr.wgetch();





ensure
Ncurses.endwin();

end
