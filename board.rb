require "./common"
require "ncursesw"
# include Ncurses

class Board
  include Common
  def initialize(yCoor,xCoor)
    @m_pWin=WINDOW.new(M_HEIGHT,M_WIDTH,yCoor,xCoor)
    @m_pWin.keypad(TRUE)
    @m_missTab=Array.new(M_NUMOFSQUARES,0)
    @m_missCount=0;
  end
  def drawBoard(pFleet=0)
    @m_pWin.wclear()
    @m_pWin.box(0,0)
    (M_HEIGHTSTEP..M_HEIGHT-1).each do |x|
      if x%M_HEIGHTSTEP==0
        @m_pWin.mvwhline(x,1,ACS_HLINE,M_HORIZONTALLENGTH)
      end
    end
    (M_WIDTHSTEP..M_WIDTH-1).each do |x|
      if x%M_WIDTHSTEP==0
        @m_pWin.mvwvline(1,x,ACS_VLINE,M_VERTICALLENGTH)
      end
    end
    if pFleet!=0
      pFleet.printFleet()
    end
    i=0
    while i<@m_missCount
      @m_pWin.mvwprintw(@m_missTab[i],@m_missTab[i+1],"0")
      i+=2
    end
    @m_pWin.wrefresh()
  end
  def setMiss(y,x)
    @m_missTab[@m_missCount]=y
    @m_missTab[@m_missCount+1]=x
    @m_missCount+=2
  end

end
