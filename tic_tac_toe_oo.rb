# tic_tac_toe_oo.rb
#
# Tealeaf Course 1 -- Lesson 2 Assignment
# Feb/11/2015

class DataValidation
  def self.options_include?(options = ['Y', 'N'], choose)
    choose = choose.upcase
    options.include?(choose)
  end

  def self.continue_next(choose)
    choose = choose.upcase
    choose == 'Y'
  end
end

class Board
  attr_accessor :status
  
  def initialize
    @status = {}  
    (1..9).each{|position| status[position] = ' '}  
  end

  def draw
    system 'clear'
    puts "     |     |     "
    puts "  #{status[1]}  |  #{status[2]}  |  #{status[3]}   "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{status[4]}  |  #{status[5]}  |  #{status[6]}   "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{status[7]}  |  #{status[8]}  |  #{status[9]}   "
    puts "     |     |     "
    puts  
  end

  def input_validation(position_choose) 
    status[position_choose] == ' '
  end
end

class Player
  attr_accessor :name, :signal
  
  def initialize(name, signal)
    @name = name
    @signal = signal
  end
end

class Game
  attr_accessor :board, :first_player, :player_turn, :player, :computer
  
  def initialize
    @board = Board.new
    @player = Player.new('Vic','X')
    @computer = Player.new('Computer','O')    
  end

  # checks to see if two in a row
  def computer_AI_choose
    winning_lines = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    # first try to win
    winning_lines.each do |line|
      test_line = {line[0] => board.status[line[0]],line[1] => board.status[line[1]], line[2] => board.status[line[2]]}
      if test_line.values.count(computer.signal) == 2 and test_line.values.count(' ') == 1
        return test_line.select{ |_,v| v == ' ' }.keys.first
      end
    end

    # second try to stop player wins
    winning_lines.each do |line|
      test_line = {line[0] => board.status[line[0]],line[1] => board.status[line[1]], line[2] => board.status[line[2]]}
      if test_line.values.count(player.signal) == 2 and test_line.values.count(' ') == 1
        return test_line.select{ |_,v| v == ' ' }.keys.first
      end
    end

    # last make a random choise
    return Random.new.rand(1..9)
  end

  def has_result
    winning_lines = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    winning_lines.each do |line|
      if board.status[line[0]] == player.signal and board.status[line[1]] == player.signal and board.status[line[2]] == player.signal
        winner_annoucement(player.signal)
        return true
      elsif board.status[line[0]] == computer.signal and board.status[line[1]] == computer.signal and board.status[line[2]] == computer.signal
        winner_annoucement(computer.signal)
        return true
      end
    end
    tie = true
    board.status.each do |key,value|
      if value == ' '
        tie = false
      end
    end
    if tie
      winner_annoucement('tie')
      true
    else
      false
    end
  end

  def winner_annoucement(signal)
    if signal == 'tie'
      puts "It's a tie!"
    elsif signal == player.signal
      puts "You won!"
    else
      puts "Computer won!"
    end
  end

  def play
    board.draw

    first_player = who_is_first
    if first_player == 'You'
      player_turn = true
    else
      player_turn = false
    end
    begin
      board.draw
      puts "The first player is: #{first_player}"
      if player_turn
        # player's turn
        begin                 
          puts "Choose a position (from 1 to 9) to place a piece:"
          position_choose = gets.chomp.to_i
        end while !board.input_validation(position_choose)
      else
        # computer's turn
        begin
          puts "Computer's turn"
          position_choose = computer_AI_choose
          puts position_choose
        end while !board.input_validation(position_choose)
      end

      board.status[position_choose] = player_turn ? player.signal : computer.signal
     
      # change roles
      player_turn = !player_turn
      board.draw
    end while !has_result
  end

  def who_is_first
    puts "Press ENTER to see who will be the first to play?"
    i = 0
    first_player = ' '
    who_is_first_thread = Thread.new do    
      while true
        if i % 2 == 0 
          first_player = "You     "
          print first_player
          print "\r"
        else
          first_player = "Computer"
          print first_player
          # STDOUT.flush
          print "\r"
        end
        i += 1
        sleep 0.1
      end
    end

    gets
    who_is_first_thread.kill

    if first_player == "You     "
      "You"
    else
      "Computer"
    end 
  end  
end

begin
  game = Game.new
  game.play
  begin 
    puts "Play again? (Y/N)"
    continue = gets.chomp
  end while !DataValidation.options_include?(choose = continue)
end while DataValidation.continue_next(continue)
