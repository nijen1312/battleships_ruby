require "./common"
require "./submarine"
require "./patrol"
require "./destroyer"
require "./cruiser"
require "ncursesw"

class Fleet
  include Common
  def initialize(size,window)
    @m_fleetSize=size
    @m_realFleetSize=0
    @m_pWin=window
    @m_fleetArray=Array.new(@m_fleetSize)
  end

end
