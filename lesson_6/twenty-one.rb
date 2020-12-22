require 'pry'
require 'pry-byebug'

CARD_NAMES = {two: "2", three: "3", four: "4", five: "5", six: "6", seven: "7", eight: "8", nine: "9",
                ten: "10", jack: "Jack", queen: "Queen", king: "King", ace: "Ace"}
CARD_VALUES = {two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9, ten: 10,
                jack: 10, queen: 10, king: 10, ace: 11}

def prompt(str)
  puts "=> #{str}"
end

def initialize_deck
  cards = %w[two three four five six seven eight nine ten jack queen king ace]
  deck = {}
  cards.each do |card|
    deck[card.to_sym] = 4
  end
  deck
end

def deal_initial_cards(deck, p_hand, d_hand)
  p_hand.push(deal_card(deck)).push(deal_card(deck))
  d_hand.push(deal_card(deck)).push(deal_card(deck))
  prompt "Dealer has: #{CARD_NAMES[d_hand.first]} and unknown card"
  prompt "You have: #{CARD_NAMES[p_hand.first]} and #{CARD_NAMES[p_hand.last]}"
end

# Returns deck card symbol i.e. :two or :king
def deal_card(deck)
  card = deck.select {|_, count| count > 0 }.keys.sample
  deck[card] -= 1
  card
end

def get_score(hand)
  aces_count = hand.count(:ace)
  score = hand.map {|card| CARD_VALUES[card]}.reduce(:+)
  while aces_count > 0 && score > 21
    score -= 10
    aces_count -= 1
  end
  score
end

def bust?(hand)
  get_score(hand) > 21 ? true: false
end

def player_turn(deck, p_hand)
  loop do
    hand = p_hand.map {|card| CARD_NAMES[card].to_s}
    prompt "Current hand: #{hand.join(', ')}. Would you like to 'hit' or 'stay'?"
    answer = gets.chomp
    break if answer == 'stay'
    if answer != 'hit'
      prompt "Incorrect command. Choose 'hit' or 'stay'."
      next
    end
    p_hand.push(deal_card(deck))
    break if bust?(p_hand)
  end
end

def dealer_turn(deck, d_hand)
  
end

def declare_winner(p_score, d_score)

end

# Start program
deck = {}

prompt "Welcome to Twenty-One!"
loop do
  deck = initialize_deck
  player_hand = []
  dealer_hand = []
  deal_initial_cards(deck, player_hand, dealer_hand)
  player_turn(deck, player_hand)
  if bust?(player_hand)
    prompt "Player busts! Dealer wins!"
    break
  end
  # START WORKING HERE
  dealer_turn(deck, dealer_hand)
  if bust?(dealer_hand)
    prompt "Dealer busts! Player wins!"
    break
  end
  declare_winner(player_score, dealer_score)
  prompt "Play again? (y/n)"
  answer = gets.chomp.downcase
  break unless answer.start_with('y')
end

prompt "Thanks for playing Twenty-One. See you next time!"
