class Tile
  attr_accessor :bomb, :flag, :revealed, :count

  def initialize
    @bomb = false
    @flag = false
    @revealed = false
    @count = 0
  end

  def reveal
    @revealed = true
  end
end
