class Player
  MARKERS = ['X', 'O']
  attr_accessor :name, :marker

  def initialize(name)
    @name = name == '' ? 'You' : name
    @marker = name == 'The Computer' ? MARKERS[1] : MARKERS[0]
  end

  def make_move(board)
    if name == 'The Computer'
      computer_move(board)
    else
      human_move(board)
    end
  end

  def computer_move(board)
    win_move = board.win_or_block_move(marker)
    block_move = board.win_or_block_move(MARKERS[0])
    
    if  win_move
      board.state[win_move] = marker
    elsif block_move
      board.state[block_move] = marker
    else
      board.state[board.random_move] = marker
    end
    
    board.display("#{name} moved:")
  end

  def human_move(board)
    begin
      try_again = false
      print "Choose a number (1-9) to place a piece ==> "
      input = gets.chomp.to_i - 1
      if valid?(input, board)
        board.state[input] = marker
        system "clear"
        board.display("#{name} moved:")
      else
        puts "That value isn't an option. Please try again."
        try_again = true
      end
    end while try_again
  end  

  def valid?(input, board)
    input >= 0 && input <= 8 && board.state[input] == ' '
  end
end


class Board
  WIN_PATTERNS = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

  attr_accessor :state

  def initialize
    @state = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
  end

  def display(message)
    puts message
    puts "\n" +
         "      |     |      \n" +
         "   #{state[0]}  |  #{state[1]}  |  #{state[2]}   \n" +
         " -----+-----+----- \n" +
         "   #{state[3]}  |  #{state[4]}  |  #{state[5]}   \n" +
         " -----+-----+----- \n" +
         "   #{state[6]}  |  #{state[7]}  |  #{state[8]}   \n" +
         "      |     |      \n\n"
  end

  def random_move
    empty_indices = []    
    state.each_with_index do |item, index|
      if item == ' '
        empty_indices.push(index)
      end
    end
    empty_indices.sample
  end

  def win_or_block_move(marker)
    block_index = false
    WIN_PATTERNS.each do |pattern|
      test_array = pattern.map{ |x| state[x] }
      if test_array.count(marker) == 2 && test_array.count(' ') == 1
        block_index = pattern[test_array.index(' ')]
        break
      end
    end
    block_index
  end

  def end_game?(player)
    WIN_PATTERNS.each do |pattern|
      test_array = pattern.map{ |x| state[x] }
      if test_array.count(player.marker) == 3
        puts "#{player.name} won!!"
        return true
      elsif !spaces_left?
        puts "No more moves. Game is a draw."
        return true
      end
    end
    false
  end

  def spaces_left?
    state.include?(' ')
  end
end


class Game
  def play(player1, player2, board)
    loop do
      player1.make_move(board)
      if board.end_game?(player1)
        return
      end

      player2.make_move(board)
      if board.end_game?(player2)
        return
      end
    end
  end

  def play_again?
    print "Play again? (y/n) ==> "
    gets.chomp.downcase
  end
end


def play_game
  system "clear"
  puts "Play Tic Tac Toe!"
  puts "~~~~~~~~~~~~~~~~~\n\n"

  print "Please enter your name ==> "
  player1 = Player.new(gets.chomp)
  player2 = Player.new('The Computer')

  begin
    board = Board.new
    game = Game.new
    system "clear"
    board.display("Starting a new game:")
    game.play(player1, player2, board)
  end while game.play_again? == "y"
end

play_game
