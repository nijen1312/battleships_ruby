require "./common"
require "ncursesw"

class Ship
  @@m_counter=0
  def initialize(hostality,battleshipLength,window)
    @m_battleshipLength=battleshipLength
    @m_hitsTaken=Array.new(@m_battleshipLength,0)
    @m_xCoordinates=-2
    @m_yCoordinates=-1
    @m_isPlaced=false
    @m_orientation=@@m_counter%2
    @@m_counter+=1
  end
  def calcModuleCoordinates()

  end
end
