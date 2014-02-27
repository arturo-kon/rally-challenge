require 'spec_helper'

feature 'Poker Hand' do

  it 'should return a proper string for a poker hand' do
    hand = 'Ah As 8d 6c 3h'
    poker = PokerHand.new(hand.split(' '))
    rank = poker.rank_to_string
    expect(rank).to eq 'Pair of Aces Eight High'
  end
end