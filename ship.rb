require "./common"
require "ncursesw"
include Ncurses
class Ship
  include Common
  attr_accessor :m_xCoordinates, :m_yCoordinates, :m_isPlaced, :m_battleshipLength, :m_battleshipLengthInUnits, :m_orientation
  @@m_counter=0
  def initialize(hostality,battleshipLength,window)
    @m_pWin=window
    @m_hostality=hostality
    @m_battleshipLength=battleshipLength
    @m_hitsTaken=Array.new(@m_battleshipLength,0)
    @m_xCoordinates = -2
    @m_yCoordinates = -1
    @m_isPlaced = false
    @m_orientation = (@@m_counter%2 == 0 ? false : true)
    @m_battleshipLengthInUnits = (@m_orientation ? M_WIDTHSTEP*(m_battleshipLength-1) : M_HEIGHTSTEP*(m_battleshipLength-1))
    @@m_counter=@@m_counter+1

    # end
    # @m_battleshipLengthInUnits=(battleshipLength-1)*
  end
  def calcModuleCoordinates!(moduleY,moduleX,moduleNumber)
    if @m_orientation
      moduleY=@m_yCoordinates
      moduleX=@m_xCoordinates+M_WIDTHSTEP*moduleNumber
    else
      moduleX=@m_xCoordinates
      moduleY=@m_yCoordinates+M_HEIGHTSTEP*moduleNumber
    end
    return [moduleY,moduleX]
  end
  def printShip(y=@m_yCoordinates,x=@m_xCoordinates)
    # @m_pWin.wrefresh()
    i=j=0
    if @m_orientation
      while i<=@m_battleshipLengthInUnits
        if @m_hitsTaken[j]==0
          if !@m_hostality
            @m_pWin.mvwprintw(y,x+i,"#")
          end
        else
          @m_pWin.mvwprintw(y,x+i,"x")
        end
        i+=M_WIDTHSTEP
        j+=1
      end
    else
      while i<=@m_battleshipLengthInUnits
        if @m_hitsTaken[j]==0
          if !@m_hostality
            @m_pWin.mvwprintw(y+i,x,"#")
          end
        else
          @m_pWin.mvwprintw(y+i,x,"x")
        end
        i+=M_HEIGHTSTEP
        j+=1
      end
    end
    @m_pWin.wrefresh()
  end
  def calcFutureCoordinates!(by,bx,ey,ex,key)
    case key
    when KEY_UP
      by = by - M_HEIGHTSTEP
    when KEY_DOWN
      by = by + M_HEIGHTSTEP
    when KEY_LEFT
      bx = bx - M_WIDTHSTEP
    when KEY_RIGHT
      bx = bx + M_WIDTHSTEP
    end
    if @m_orientation
      ey=by
      ex=bx+@m_battleshipLengthInUnits
    else
      ex=by
      ey=by+@m_battleshipLengthInUnits
    end
    return [by,bx,ey,ex]
  end
  def checkValidCoordinates(c=0)
    futureBegY=futureEndY=@m_yCoordinates
    futureBegX=futureEndX=@m_xCoordinates
    if c!=0
      coorArr1=calcFutureCoordinates!(futureBegY,futureBegX,futureEndY,futureEndX,c)
      a=coorArr1
    else
      coorArr2=calcModuleCoordinates!(futureEndY,futureEndX,@m_battleshipLength-1)
      a=[futureBegY,futureBegX]+coorArr2
    end
    if @m_orientation
      if (a[0]<M_FIRSTY || a[0]>M_LASTY||a[1]<M_FIRSTX || a[1]>M_LASTX||a[3]<M_FIRSTX || a[3]>M_LASTX)
        return false
      end
    else
      if (a[1]<M_FIRSTX || a[1]>M_LASTX || a[0]<M_FIRSTY || a[0]>M_LASTY || a[2]<M_FIRSTY || a[2]>M_LASTY)
        return false
      end
    end
    return true
  end

end
