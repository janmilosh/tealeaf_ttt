require 'pry'

puts "Play Tic Tac Toe!"

$game_state = []
WIN_PATTERNS = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

def display_game_board
  game_board = "\n" +
               "      |     |      \n" +
               "   #{$game_state[0][0]}  |  #{$game_state[1][0]}  |  #{$game_state[2][0]}   \n" +
               " -----+-----+----- \n" +
               "   #{$game_state[3][0]}  |  #{$game_state[4][0]}  |  #{$game_state[5][0]}   \n" +
               " -----+-----+----- \n" +
               "   #{$game_state[6][0]}  |  #{$game_state[7][0]}  |  #{$game_state[8][0]}   \n" +
               "      |     |      \n\n"
  puts game_board
end

def create_initial_game_state
  9.times do |i|
    $game_state[i] = [' ', 0]
  end
end

def declare_a_winner?
  end_game = false
  WIN_PATTERNS.each do |pattern|
    total = 0
    pattern.each do |item|
      total += $game_state[item][1]
    end
    if total == 30
      puts "You win!!!"
      end_game = true
      break
    elsif total == 3
      puts "Sorry, the computer wins."
      end_game = true
      break
    end
  end

  spaces_left = 0
  $game_state.each do |item|
    if item[0] == ' '
      spaces_left += 1
      break
    end
  end
  if spaces_left == 0
    puts "Game ends without a winner!"
    end_game = true
  end
  end_game
end

def make_player_move
  begin
    try_again = false
    puts "Choose a number (1-9) to place a piece:"
    player_input = gets.chomp.to_i - 1
    if player_input >= 0 && player_input <= 9 && $game_state[player_input][0] == ' '
      $game_state[player_input] = ['X', 10]
      puts "Here's your move:"
      display_game_board
    else
      puts "That value is not an option. Try again."
      try_again = true
    end
  end while try_again
end

def make_computer_move 
  win = false
  block = false
  WIN_PATTERNS.each do |pattern| #to win
    total = 0
    win_move = nil
    pattern.each do |item|
      if $game_state[item][1] == 0
        win_move = item
      end
      total += $game_state[item][1]
    end
    if total == 2
      $game_state[win_move] = ['O', 1]
      display_game_board
      win = true
      break
    end
  end

  if !win
    WIN_PATTERNS.each do |pattern| #to block
      total = 0
      block_move = nil
      pattern.each do |item|
        if $game_state[item][1] == 0
          block_move = item
        end
        total += $game_state[item][1]
      end
      if total == 20
        $game_state[block_move] = ['O', 1]
        display_game_board
        block = true
        break
      end
    end
  end

  if !win && !block
    available_moves = []    
    $game_state.each_with_index do |item, index|
      if item[0] == ' '
        available_moves.push(index)
      end
    end
    if available_moves.length == 0
      puts "Game ends without a winner!"
    else
      $game_state[available_moves.sample] = ['O', 1]
      puts "Here's the computer's move:"
      display_game_board
    end
  end
end


def play_game
  begin
    create_initial_game_state
    display_game_board
    
    end_game = false
    while !end_game
      
      make_player_move
      end_game = declare_a_winner?
      if end_game
        next
      end
      
      make_computer_move
      end_game = declare_a_winner?
    end

    puts "Play again? (Y/N)"
    play_again_response = gets.chomp.downcase    
  end while play_again_response == 'y'
end

play_game
  