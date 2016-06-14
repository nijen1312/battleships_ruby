require "ncursesw"
# require "./common"
require "./board"
require "./fleet"
include Ncurses

class AuxBox
  def initialize()
    @m_pWin = WINDOW.new(5,84,21,0)
  end
  def displayHints()
    @m_pWin.wrefresh()
    @m_pWin.box(0,0)
    @m_pWin.mvwprintw(1,20,"Arrow keys - move around")
    @m_pWin.mvwprintw(2,20,"R - rotate ship")
    @m_pWin.mvwprintw(3,20,"Enter - place ship (keep distance of 1 field from other ships)")
    @m_pWin.wrefresh()
  end
  def displayScore(eHP,pHP)
    mess1="Player HP: "
    mess2="Enemy HP: "
    @m_pWin.getmaxyx(y=[],x=[])
    @m_pWin.wclear()
    @m_pWin.box(0,0)
    @m_pWin.mvwprintw(y/2,(x-mess1.length)/2,"%s%3d",mess1,pHP)
    @m_pWin.mvwprintw((y/2)+1,(x-mess2.length)/2,"%s%3d",mess2,eHP)
    @m_pWin.wrefresh()
  end
end
begin
  scr = Ncurses.initscr()
  Ncurses.cbreak()
  Ncurses.noecho()
  Ncurses.keypad(scr, true)
  playerBoard=Board.new(0,0)
  playerFleet=Fleet.new(4,playerBoard)
  enemyBoard=Board.new(0,42)
  enemyFleet=Fleet.new(4,enemyBoard)
  auxWin=AuxBox.new()
  playerFleet.initializeFleet(false)
  enemyFleet.initializeFleet(true)
  scr.refresh()
  enemyBoard.drawBoard()
  auxWin.displayHints
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
