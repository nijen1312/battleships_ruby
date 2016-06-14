require "./common"
require "./submarine"
require "./patrol"
require "./destroyer"
require "./cruiser"
require "ncursesw"

class Fleet
  include Common
  attr_accessor :m_HP, :m_pBoard
  def initialize(size,board)
    @m_fleetSize=size
    @m_realFleetSize=0
    @m_pBoard=board
    @m_pWin=board.m_pWin
    @m_fleetArray=Array.new(@m_fleetSize)
  end
  def checkColision(ship)
    #&&
    curShipModuleY=curShipModuleX=placedShipModuleY=placedShipModuleX=0
    @m_fleetArray.each do |e|
      if (e!=nil && e.m_isPlaced)
        ship.m_battleshipLength.times do |j|
          a1=ship.calcModuleCoordinates!(j)
          e.m_battleshipLength.times do |k|
            a2=e.calcModuleCoordinates!(k)
            xd=(a1[1]-a2[1]).abs
            yd=(a1[0]-a2[0]).abs
            return false if (xd<=M_WIDTHSTEP && yd <= M_HEIGHTSTEP)
          end
        end
      end
    end
    return true
  end
  def initializeFleet(hostality)
    destroyerLength=5
    cruiserLength=4
    patrolLength=2
    submarineLength=3
    @m_HP=destroyerLength+submarineLength+patrolLength+cruiserLength
    i=0
    while i<@m_fleetSize
      case i%4
      when 0
        @m_fleetArray[i]=Destroyer.new(hostality,destroyerLength,@m_pWin)
      when 1
        @m_fleetArray[i]=Cruiser.new(hostality,cruiserLength,@m_pWin)
      when 2
        @m_fleetArray[i]=Patrol.new(hostality,patrolLength,@m_pWin)
      when 3
        @m_fleetArray[i]=Submarine.new(hostality,submarineLength,@m_pWin)
      end
      if hostality
        while (checkColision(@m_fleetArray[i]) != @m_fleetArray[i].checkValidCoordinates())
          @m_fleetArray[i].m_yCoordinates=M_FIRSTY+rand(10)*M_HEIGHTSTEP
          @m_fleetArray[i].m_xCoordinates=M_FIRSTX+rand(10)*M_WIDTHSTEP
        end
        @m_fleetArray[i].m_isPlaced=true
      end
      i+=1
      @m_realFleetSize+=1
    end
  end

  def printFleet()
    @m_fleetSize.times{|i| @m_fleetArray[i].printShip() if (@m_fleetArray[i].m_yCoordinates!=-1)}
  end
  def deployFleet()
    Ncurses.keypad(@m_pWin, true)
    i = 0
    c = 1
    @m_fleetArray[i].m_yCoordinates=M_FIRSTY
    @m_fleetArray[i].m_xCoordinates=M_FIRSTX
    @m_fleetArray[i].printShip()
    @m_pWin.wrefresh()
    while (c!="q".ord && i< @m_fleetSize)
      c=@m_pWin.wgetch()
      if @m_fleetArray[i].checkValidCoordinates(c)
        case c
        when KEY_UP
          @m_fleetArray[i].m_yCoordinates=(@m_fleetArray[i].m_yCoordinates-M_HEIGHTSTEP)
        when KEY_DOWN
          @m_fleetArray[i].m_yCoordinates=(@m_fleetArray[i].m_yCoordinates+M_HEIGHTSTEP)
        when KEY_LEFT
          @m_fleetArray[i].m_xCoordinates=(@m_fleetArray[i].m_xCoordinates-M_WIDTHSTEP)
        when KEY_RIGHT
          @m_fleetArray[i].m_xCoordinates=(@m_fleetArray[i].m_xCoordinates+M_WIDTHSTEP)
        when "r".ord
          if @m_fleetArray[i].m_orientation==true
            @m_fleetArray[i].m_orientation=false if (!((@m_fleetArray[i].m_yCoordinates()+M_HEIGHTSTEP*(@m_fleetArray[i].m_battleshipLength()-1))>M_LASTY))
            @m_fleetArray[i].m_battleshipLengthInUnits=M_HEIGHTSTEP*(@m_fleetArray[i].m_battleshipLength-1)
          else
            @m_fleetArray[i].m_orientation=true if (!((@m_fleetArray[i].m_xCoordinates()+M_WIDTHSTEP*(@m_fleetArray[i].m_battleshipLength()-1))>M_LASTX))
            @m_fleetArray[i].m_battleshipLengthInUnits=M_WIDTHSTEP*(@m_fleetArray[i].m_battleshipLength-1)
          end
        when "\n".ord
          if checkColision(@m_fleetArray[i])
            @m_fleetArray[i].m_isPlaced=true
            i=i+1;
            if i<@m_fleetSize
              @m_fleetArray[i].m_yCoordinates=M_FIRSTY
              @m_fleetArray[i].m_xCoordinates=M_FIRSTX
            end
          end
        end
        if i<@m_fleetSize
          @m_pWin.wclear()
          @m_fleetArray[i].printShip()
          @m_pBoard.drawBoard(self)
          @m_pWin.wrefresh()
        end
      end
    end
  end
  def checkHit(y,x)
     @m_fleetSize.times do |i|
       @m_fleetArray[i].m_battleshipLength.times do |k|
        a=@m_fleetArray[i].calcModuleCoordinates!(k)
        xd=(x-a[1]).abs
        yd=(y-a[0]).abs
        if (xd == 0 && yd == 0 && @m_fleetArray[i].m_hitsTaken[k]==0)
          @m_fleetArray[i].m_hitsTaken[k]=1
          @m_HP-=1
          return true
        end
        if (xd == 0 && yd == 0 && @m_fleetArray[i].m_hitsTaken[k]==1)
          return true
        end
      end
    end
    return false
  end



end
