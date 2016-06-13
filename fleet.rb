require "./common"
require "./submarine"
require "./patrol"
require "./destroyer"
require "./cruiser"
require "ncursesw"

class Fleet
  include Common
  #attr_accessor:
  def initialize(size,window)
    @m_fleetSize=size
    @m_realFleetSize=0
    @m_pWin=window
    @m_fleetArray=Array.new(@m_fleetSize)
  end
  def checkColision(ship)
    #&& e.m_isPlaced
    curShipModuleY=curShipModuleX=placedShipModuleY=placedShipModuleX=0
    @m_fleetArray.select do |e| e!=nil
        ship.m_battleshipLength.times do |j|
          ship.calcModuleCoordinates!(curShipModuleY,curShipModuleX,j)
          e.m_battleshipLength.times do |k|
            e.calcModuleCoordinates(placedShipModuleY,placedShipModuleX,k)
            xd=(curShipModuleX-placedShipModuleX).abs
            yd=(curShipModuleY-placedShipModuleY).abs
            return false if (xd<=M_WIDTHSTEP && yd <= M_HEIGHTSTEP)
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
        @m_fleetArray[i]=Cruiser.new(hostality,destroyerLength,@m_pWin)
      when 2
        @m_fleetArray[i]=Patrol.new(hostality,destroyerLength,@m_pWin)
      when 3
        @m_fleetArray[i]=Submarine.new(hostality,destroyerLength,@m_pWin)
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

  end
end
