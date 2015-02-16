# In our rock, paper, scissors a human player chooses a hand (r,p,s) and a computer player chooses a hand(rps).
# Both players show their hand
# Hands are compared and winner is declared
#test

class Player
  attr_accessor :hand
  attr_reader :name

  def initialize(n)
    @name = n
  end

  def to_s
    "#{name} has a choice of #{self.hand.value}"
  end
end

class Hand
  include Comparable
  attr_accessor :value

  def initialize(v)
    @value = v
  end

  def <=> (another_hand)
    if @value == another_hand.value
      0
    elsif (@value == 'r' && another_hand.value == 's') || (@value == 'p' && another_hand.value == 'r') || (@value == 's' && another_hand.value == 'p')
      1
    else
      -1
    end
  end
end

class Human < Player
  def pick_hand
    begin
      puts "Please pick either rock, paper or scissors (r/p/s)"
      choice = gets.chomp.downcase
    end until choice == 'r' || choice == 'p' || choice =='s'
    self.hand = Hand.new(choice)
  end
end


class Computer < Player
  def pick_hand
    self.hand = Hand.new(Game::CHOICES.keys.sample)
  end
end

class Game
  CHOICES = { 'r' => 'rock', 'p' => 'paper', 's' => 'scissors' }
  attr_accessor :player, :computer

  def initialize
    @player = Human.new('Tyler')
    @computer = Computer.new('Siri')
  end

  def play
    puts 'Welcome to rock, paper scissors'
    computer.pick_hand
    player.pick_hand
    compare_hands

    puts player
    puts computer
  end

  def compare_hands
    if player.hand == computer.hand
      puts "It's a tie"
    elsif player.hand > computer.hand
      puts "#{player.name} won!"
    else
      puts "#{computer.name} won!"
    end
  end
end

game = Game.new.play

