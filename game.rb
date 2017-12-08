require_relative 'board'

class Game

  def initialize
    @board = Board.new
  end

  def play

  end

  def check_tile(pos)
    if @board.contains_bomb?(pos)
      puts "Game Over."
    else
      @board.reveal_tile(pos)
    end
  end

  def won?
    @board.won?
  end

end
