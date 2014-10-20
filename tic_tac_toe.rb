puts "Play Tic Tac Toe!"

WIN_PATTERNS = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

def display_game_board(game_state)
  game_board = "\n" +
               "      |     |      \n" +
               "   #{game_state[0][0]}  |  #{game_state[1][0]}  |  #{game_state[2][0]}   \n" +
               " -----+-----+----- \n" +
               "   #{game_state[3][0]}  |  #{game_state[4][0]}  |  #{game_state[5][0]}   \n" +
               " -----+-----+----- \n" +
               "   #{game_state[6][0]}  |  #{game_state[7][0]}  |  #{game_state[8][0]}   \n" +
               "      |     |      \n\n"
  puts game_board
end

def create_initial_game_state
  game_state = []
  9.times do |i|
    game_state[i] = [' ', 0]
  end
  game_state
end

def declare_a_winner?(game_state)
  end_game = false
  WIN_PATTERNS.each do |pattern|
    total = 0
    pattern.each do |item|
      total += game_state[item][1]
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
  game_state.each do |item|
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

def check_for_block_or_win(needed_total, game_state)
  block_or_win = false
  WIN_PATTERNS.each do |pattern|
    total = 0
    move = nil
    pattern.each do |item|
      if game_state[item][1] == 0
        move = item
      end
      total += game_state[item][1]
    end
    if total == needed_total
      game_state[move] = ['O', 1]
      if needed_total == 20
        puts "The computer moves to block:"
      elsif needed_total == 2
        puts "The computer moves to win:"
      end

      display_game_board(game_state)
      block_or_win = true
      break
    end
  end
  block_or_win
end

def find_random_move(game_state)
  available_moves = []    
  game_state.each_with_index do |item, index|
    if item[0] == ' '
      available_moves.push(index)
    end
  end
  if available_moves.length == 0
    puts "Game ends without a winner!"
  else
    game_state[available_moves.sample] = ['O', 1]
    puts "The computer makes a random move:"
    display_game_board(game_state)
  end
end

def make_computer_move(game_state) 
  win = check_for_block_or_win(2, game_state) # 2 is the line total for a block
  if !win
    block = check_for_block_or_win(20, game_state) # 20 is the line total for a win
  end
  if !win && !block 
    find_random_move(game_state) 
  end
end

def make_player_move(game_state)
  begin
    try_again = false
    puts "Choose a number (1-9) to place a piece:"
    player_input = gets.chomp.to_i - 1
    if player_input >= 0 && player_input <= 9 && game_state[player_input][0] == ' '
      game_state[player_input] = ['X', 10]
      puts "Here's your move:"
      display_game_board(game_state)
    else
      puts "That value is not an option. Try again."
      try_again = true
    end
  end while try_again
end

begin
  game_state = create_initial_game_state
  display_game_board(game_state)
  
  end_game = false
  while !end_game
    
    make_player_move(game_state)
    end_game = declare_a_winner?(game_state)
    if end_game
      next
    end
    make_computer_move(game_state)
    end_game = declare_a_winner?(game_state)
  end

  puts "Play again? (Y/N)"
  play_again_response = gets.chomp.downcase    
end while play_again_response == 'y'
