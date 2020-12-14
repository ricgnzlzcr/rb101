VALID_CHOICES = %w[rock paper scissors lizard spock]

def prompt(message)
  puts("=> #{message}")
end

def player_wins?(player, cpu)
  winners = {
              "rock" => ["lizard", "scissors"],
              "paper" => ["rock", "spock"],
              "scissors" => ["paper", "lizard"],
              "lizard" => ["paper", "spock"],
              "spock" => ["rock", "scissors"]
  }
  if player == cpu
    return 0
  end
  winners[player].include?(cpu) ? 1 : -1
end

def print_winner(player_choice, cpu_choice)
  result = player_wins?(player_choice, cpu_choice)
  if result > 0
    prompt("Player's #{player_choice} defeats computer's #{cpu_choice}")
  elsif result < 0
    prompt("Computer's #{cpu_choice} defeat's player's #{player_choice}")
  else
    prompt("Tie game!")
  end
end

player_score = 0
cpu_score = 0

loop do
  choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = gets.chomp.downcase
    break if VALID_CHOICES.include?(choice)
    prompt("That's not a valid choice!")
  end
  computer_choice = VALID_CHOICES.sample
  print_winner(choice, computer_choice)
  match_result = player_wins?(choice, computer_choice)
  if match_result > 0
    player_score += 1
    if player_score == 5
      prompt("You are Grand Winner with 5 wins!")
      break
    end
  elsif match_result < 0
    cpu_score += 1
    if cpu_score == 5
      prompt("Computer is Grand Winner with 5 wins!")
      break
    end
  end
  prompt("Would you like to keep playing? (y/n)")
  keep_playing = gets.chomp.downcase
  if !keep_playing.start_with?('y')
    prompt("Thank's for playing!")
    break
  end
end
