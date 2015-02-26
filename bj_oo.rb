# In BlackJack a dealer(the house) plays against 1 or many players.
# Each player must make a bet to play the hand
# Each player and the dealer are dealt 2 cards.
# Players have the option to hit or stay on their turn
# Once all players have gone the dealer plays, they must hit on anything under 17
# If player has better hand than dealer then they win their bet, if not the dealer takes it

# Nouns: Dealer, Player, Deck, Card, Hand, Bet
# Verbs: deal, bet, hit, stay, compare_hands 

class Deck
  attr_accessor :cards_in_deck

  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
  SUITS = ['Clubs', 'Diamonds', 'Hearts', 'Spades']
  VALUES = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
          10 => 10, 'Jack' => 10, 'Queen' => 10, 'King' => 10, 'Ace' => 11}
  
  def initialize
    @cards_in_deck = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        @cards_in_deck << Card.new(rank, suit)
      end
    end
    scramble!
  end

  def scramble!
    cards_in_deck.shuffle!
  end

  def deal_one
    cards_in_deck.pop
  end

  def cards_left
    cards_in_deck.count
  end
end


class Card
  attr_accessor :rank, :suit, :value

  def initialize (rank, suit)
    @rank = rank
    @suit = suit
    @value = Deck::VALUES[rank]
  end

  def to_s
    "#{rank} of #{suit}"
  end
end


module Blackjack
  def add_card_to_hand(new_card)
    hand << new_card
  end

  def total
    total = 0
    aces = hand.select { |card| card.rank == 'Ace'} 
    hand.each { |card| total += card.value}
    if total > 21
      aces.count.times do 
        if total > 21
          total -= 10
        end
      end
    end
    total
  end

  def show_hand
    puts "#{name} has:"
    hand.each do |card|
      puts "=> #{card}"
    end
  end

  def show_total
    sum = self.total
    puts "Total = #{sum}"
  end

  def busted?
    self.total > 21
  end

  def reset_hand
    self.hand = []
  end

end


class Player
  include Blackjack
  attr_accessor :money, :name, :hand, :bet

  def initialize(name)
    @money = 0
    @name = name
    @hand = []
    @bet = 0
  end

  def bet_this_hand
    begin
      puts "What would you like to bet this hand?"
      self.bet = gets.chomp.to_i
      if bet > money
        puts "You only have $#{money}, you can't bet more than that."
      end
    end while bet > money
  end

  def cash_in
    puts "How much money would you like to play with?"
    answer = gets.chomp.to_i
    self.money = answer
  end

  def busted
    self.money -= self.bet
    puts "Oops you busted"
    puts "You lost $#{bet} and now have $#{money} left."
  end

end


class Dealer
  include Blackjack
  attr_accessor :hand, :name

  def initialize
    @name = 'Dealer'
    @hand = []
  end

  def show_upcard
    puts "Dealer is showing #{hand[0]}"
  end
end


class Game
  attr_accessor :player, :dealer, :deck

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new('Tyler')
  end

  def welome_message
    puts "Welcome to Blackjack, Good Luck"
  end

  def intial_deal
    player.add_card_to_hand(deck.deal_one)
    dealer.add_card_to_hand(deck.deal_one)
    player.add_card_to_hand(deck.deal_one)
    dealer.add_card_to_hand(deck.deal_one)
    dealer.show_upcard
    player.show_hand
  end

   def hit_or_stay
    begin
      puts "Would you like to hit or stay (h/s)"
      answer = gets.chomp.downcase
      if answer == 'h'
        player.add_card_to_hand(deck.deal_one)
        player.show_hand
        player.show_total
      elsif answer == 's'
        puts "#{player.name} stays."
      else
        puts "I don't recognize that input"
      end
    end until answer == 's' || player.total > 21
  end

  def dealer_plays
    while dealer.total < 17
      dealer.add_card_to_hand(deck.deal_one)
    end
    dealer.show_hand
    dealer.show_total
  end

  def dealer_busted
    puts "Dealer has busted"
    player.money += player.bet
    puts "You win $#{player.bet} and now have $#{player.money}"
  end

  def winner
    puts "You WIN!"
    player.money += player.bet
    puts "You won $#{player.bet} and now have $#{player.money}"
  end

  def loser
    puts "Dealer wins"
    player.money -= player.bet
    puts "You lost $#{player.bet} and now have $#{player.money} left."
  end

  def player_blackjack
    puts "BLACKJACK!!!"
    player.money += (player.bet * 1.5)
    puts "You won $#{player.bet * 1.5} and now have $#{player.money}"
  end

  def run
    welome_message
    player.cash_in
    begin
      player.bet_this_hand
      intial_deal
      if player.total == 21
        player_blackjack
      else
        hit_or_stay
        if player.busted?
          player.busted
        else
          dealer_plays
          if dealer.busted?
            dealer_busted
          else
            if player.total > dealer.total
              winner
            else
              loser
            end
          end
        end
      end
      player.reset_hand
      dealer.reset_hand
      puts "Would you like to play another hand? (y/n)"
      play_again = gets.chomp.downcase
    end while play_again == 'y' && deck.cards_left > 15
    if deck.cards_left <= 15
      puts "Not enough cards"
      puts "We'll have to start a new game"
    end
  end
end

Game.new.run




















