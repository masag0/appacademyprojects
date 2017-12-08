require 'byebug'
require_relative 'tile'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9) do
      Array.new(9) { Tile.new }
    end
  end

  def [](pos)
    @grid[pos.first][pos.last]
  end

  def contains_bomb?(pos)
    self[pos].bomb
  end

  def populate
    @grid.each do |array|
      array.each do |tile|
        tile.bomb = true if rand(4) < 1
      end
    end
  end

  def render
    @grid.each do |array|
      array.each do |tile|
        if tile.flag
          print " F "
        elsif tile.revealed == false
          print " * "
        elsif tile.revealed
          if tile.bomb
            print " B "
          elsif tile.count > 0
            print " #{tile.count} "
          else
            print " _ "
          end
        end
      end
      puts
    end
  end

  def count_neighboring_bombs(pos)
    count = 0

    row, col = pos

    (row-1..row+1).each do |x|
      next unless (0..8).include?(x)
      (col-1..col+1).each do |y|
        next unless (0..8).include?(y)
        next if x == row && y == col
        count += 1 if @grid[x][y].bomb
      end
    end

    self[pos].count = count
  end

  def count_all_bombs
    @grid.each_with_index do |array, row|
      array.each_index do |col|
        count_neighboring_bombs([row, col])
      end
    end
  end

  def set_flag(pos)
    self[pos].flag = true
  end

  def reveal_tile(pos)
    self[pos].reveal unless self[pos].flag
  end

  def reveal_tile_chain(pos) #recursive
    # debugger
    self[pos].reveal unless self[pos].flag || self[pos].bomb

    row, col = pos

    (row-1..row+1).each do |x|
      next unless (0..8).include?(x)
      (col-1..col+1).each do |y|
        next unless (0..8).include?(y)
        next if x == row && y == col
        reveal_tile_chain([x,y]) unless self[pos].bomb ||
                                        self[pos].revealed
      end
    end


  end

  def won?
    @grid.all? do |array|
      array.reject { |tile| tile.bomb }.all? { |tile| tile.revealed }
    end
  end

end
