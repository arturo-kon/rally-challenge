require './poker_hand'

puts 'Enter Poker Hand'
begin
  a = gets.chomp
  hnd = a.split(' ')
  raise '5 cards are needed for poker ;(, please retry' if hnd.size != 5
  poker = PokerHand.new(hnd)
rescue => e
  puts e
  retry
end

rank = poker.rank_to_string(rank)
puts rank
