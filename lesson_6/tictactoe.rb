require 'pry'
require 'pry-byebug'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(arr, delimiter=', ', word='or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimiter)
  end
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |n| new_board[n] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def find_at_risk_square(line, board)
  if board.values_at(*line).count(COMPUTER_MARKER) == 2
    board.select{|k,v| line.include?(k) && v == INITIAL_MARKER}.keys.first
  else
    nil
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    # prompt("Choose a square (#{empty_squares(brd).join(', ')}):")
    prompt("Choose a position to place a piece: (#{joinor(empty_squares(brd))}):")
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt("Sorry, that's not a valid choice.")
  end

  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  WINNING_LINES.each do |line|
    player_hash = {}
    line.each do |pos|
      if brd[pos] == PLAYER_MARKER
        player_hash[pos] = PLAYER_MARKER
      elsif brd[pos] == COMPUTER_MARKER
        player_hash[pos] = COMPUTER_MARKER
      else
        player_hash[pos] = INITIAL_MARKER
      end
    end
    player_spaces_count = player_hash.values.count(PLAYER_MARKER)
    empty_square_count = player_hash.values.count(INITIAL_MARKER)
    if player_spaces_count == 2 && empty_square_count == 1
      winning_position = player_hash.key(INITIAL_MARKER)
      brd[winning_position] = COMPUTER_MARKER
      return
    end
  end
  # 
  square = nil
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd)
    break if square
  end

  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
  
  # Legacy Code
  #square = empty_squares(brd).sample
  #brd[square] = COMPUTER_MARKER
end

def block_player_win!(brd, line)
  line.each { |pos| brd[pos] = COMPUTER_MARKER if brd[pos] == INITIAL_MARKER }  
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

comp_wins = 0
player_wins = 0
loop do
  board = initialize_board

  loop do
    display_board(board)
    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
    computer_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    winner = detect_winner(board)
    prompt("#{winner} won!")
    if winner == 'Player'
      player_wins += 1
      prompt "Player has won #{player_wins} times!"
    else
      comp_wins += 1
      prompt "Computer has won #{comp_wins} times!"
    end
  else
    prompt("It's a tie!")
  end
  break if player_wins == 5 || comp_wins == 5
  prompt "Play again? (y/n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing tic tac toe. Goodbye!"
