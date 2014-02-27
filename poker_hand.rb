require './poker_rank'

class PokerHand
  include PokerRank
  def initialize(hand)
    @hand = Array.new
    hand.each do |c|
      @hand << format_card(c)
    end
  end

  private
  def format_card(h)
    # Account for 10 being two digits.
    if (h[0] == '1' and h[1] == '0')
      c = 10
      s = h[2].capitalize
    else
      c = h[0].capitalize
      s = h[1].capitalize
    end
    c = card_to_number(c) if c.to_i == 0
    raise 'Not a Valid Suit, please enter H,D,C or S' unless valid_suits.include?(s)
    raise 'Not a Valid Card, please enter 1-10 or J-A' unless valid_cards.include?(c.to_i)
    {:card => c.to_i, :suit => s}
  end

  def valid_suits
    ['H','D','C','S']
  end

  def valid_cards
    [2,3,4,5,6,7,8,9,10,11,12,13,14]
  end

  def card_to_number(c)
    t = {'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14}
    t[c]
  end
end