# write psuedo code to describe game
# prominent nouns are classes with behaviors and attributes
# game engine is where the "procedural part goes"

# 2 players take turns placing their marker on a 3x3 board. The first player to get three of their markers in a row wins,
# if all positions are full then it is a cats game

class Board
  attr_accessor :data
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

  def initialize
    @data = {}
    (1..9).each { |position| @data[position] = " "}
  end

  def draw
    system ('clear')
    puts "#{@data[1]}|#{@data[2]}|#{@data[3]}"
    puts "-+-+-"
    puts "#{@data[4]}|#{@data[5]}|#{@data[6]}"
    puts "-+-+-"
    puts "#{@data[7]}|#{@data[8]}|#{@data[9]}"
  end

  def human_pick_position
    begin
      puts "Pick any available position 1-9"
      position = gets.chomp.to_i
    end until available?(position)
    mark(position, 'X')
  end

  def computer_pick_position
    position = available_positions.sample
    mark(position, 'O')
  end

  def mark(position, marker)
    @data[position] = marker
  end

  def available_positions
    @data.select{ |_, marker| marker == " "}.keys
  end
  # returns array of empty positions
  def available?(position)
    @data[position] == " "
  end
  # returns true if position is open
  def all_positions_full?
    available_positions.empty?
  end

  def winner?
    WINNING_LINES.each do |line|
    return "Player" if @data.values_at(*line).count('X') == 3
    return "Computer" if @data.values_at(*line).count('O') == 3
    end
    nil
  end

  def clear
    @data = {}
    (1..9).each { |position| @data[position] = " "}
  end
end

class Player
  attr_reader :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end

  def player_positions
    @player_positions = @data.select { |_, marker| marker == @marker}.keys
  end
end


class Game
  def initialize
    @human = Player.new('Tyler', 'X')
    @computer = Player.new('Siri', 'O')
    @board = Board.new
    @current_player = @human 
  end

  def introduction
    puts "Welcome to tic tac toe #{@human.name}"
  end

  def alternate_player
    if @current_player == @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end

  def current_player_picks_position
    if @current_player == @computer
      @board.computer_pick_position
    else
      @board.human_pick_position
    end
  end

  def display_game_result
    if @board.winner?
      @current_player == @computer ? (puts "#{@human.name} WON!") : (puts "#{@computer.name} WON!")
    else
      puts "It's a Cat's Game"
    end
  end

  def run
    begin
      introduction
      @board.draw
      begin
        current_player_picks_position
        @board.draw
        alternate_player
      end until @board.winner? || @board.all_positions_full?
      display_game_result
      @board.clear
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
    end while answer == 'y'
  end
end

game = Game.new.run


