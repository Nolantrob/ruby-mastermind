class Player
  def initialize
    print 'What is your name?: '
    @name = gets.to_s.chomp
  end
end
