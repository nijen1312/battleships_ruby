require "ncursesw"
# require "./common"
require "./board"
require "./fleet"
include Ncurses
include Common

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
    @m_pWin.mvwprintw(y[0]/2,(x[0]-mess1.length)/2,"%s%3d",mess1,pHP)
    @m_pWin.mvwprintw((y[0]/2)+1,(x[0]-mess2.length)/2,"%s%3d",mess2,eHP)
    @m_pWin.wrefresh()
  end
  def displayWinner(w)
    mess1="You win"
    mess2="You Lose"
    mess3="Hit 'Q' to quit."
    @m_pWin.wclear()
    @m_pWin.box(0,0)
    @m_pWin.wrefresh()
    if w
      @m_pWin.mvwprintw(2,(@m_pWin.getmaxx()-mess1.length)/2,mess1)
    else
      @m_pWin.mvwprintw(2,(@m_pWin.getmaxx()-mess2.length)/2,mess2)
    end
    @m_pWin.mvwprintw(4,(@m_pWin.getmaxx()-mess3.length)/2,mess3)
    @m_pWin.wrefresh()
    while (c=Ncurses.getch() != "q".ord)

    end
  end
end
def barrage(enemyFleet,playerFleet,auxWin)
  y=M_FIRSTY
  x=M_FIRSTX
  auxWin.displayScore(enemyFleet.m_HP,playerFleet.m_HP)
  enemyFleet.m_pBoard.m_pWin.wmove(y,x)
  c=1
  while (c!="q".ord)
    c=enemyFleet.m_pBoard.m_pWin.wgetch()
    case c
    when KEY_UP
      if (y>M_FIRSTY)
        y-=M_HEIGHTSTEP
      end
    when KEY_DOWN
      if (y<M_LASTY)
        y+=M_HEIGHTSTEP
      end
    when KEY_LEFT
      if (x>M_FIRSTX)
        x-=M_WIDTHSTEP
      end
    when KEY_RIGHT
      if (x<M_LASTX)
        x+=M_WIDTHSTEP
      end
    when "\n".ord
      if !(enemyFleet.checkHit(y,x))
        enemyFleet.m_pBoard.setMiss(y,x)
      end
      ry=M_FIRSTY+rand(10)*M_HEIGHTSTEP
      rx=M_FIRSTX+rand(10)*M_WIDTHSTEP
      if !(playerFleet.checkHit(ry,rx))
        playerFleet.m_pBoard.setMiss(ry,rx)
      end
    end
  enemyFleet.m_pBoard.drawBoard(enemyFleet)
  playerFleet.m_pBoard.drawBoard(playerFleet)
  enemyFleet.m_pBoard.m_pWin.wrefresh()
  auxWin.displayScore(enemyFleet.m_HP,playerFleet.m_HP)
  enemyFleet.m_pBoard.m_pWin.wmove(y,x)
  if   (enemyFleet.m_HP==0 || playerFleet.m_HP==0)
    return (playerFleet.m_HP - enemyFleet.m_HP)
  end
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
  score=barrage(enemyFleet,playerFleet,auxWin)
  auxWin.displayWinner(score)
  # board=WINDOW.new(Common::M_HEIGHT,Common::M_WIDTH,0,0)
  # board.box(0,0)
  # board.wrefresh()
  scr.wgetch();
ensure
Ncurses.endwin();

end
