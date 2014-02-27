module PokerRank
  def get_rank
    r = rank_of_cards
    r.each do |method|
      rank = send(method)
      return method if rank
    end
  end

  def rank_to_string(method = nil)
    method = get_rank if method.nil?
    rank_string = translate_rank(method) if method

    # Add the high card.
    high_card_string = translate_card(high_card)
    if one_pair || two_pair
      return @rank_string + ' ' + high_card_string + ' High'
    end
    return rank_string + ' ' + high_card_string + ' High' if rank_string
    high_card_string + ' High' unless rank_string
  end

  def high_card
    c = @hand.group_by { |k| k[:card] }
    v = Array.new
    # Filter out all cards that are involved in a same kind position.
    c.each do |key, value|
      v << key if value.size == 1
    end
    @high_card = v.sort.last
  end

  def same_kind
    @pairs = Hash.new
    c = @hand.group_by { |k| k[:card] }
    c.each do |card, values|
      @pairs.merge!({card => values}) if values.size == 2
      @threes = {card => values} if values.size == 3
      @fours = {card => values} if values.size == 4
    end
  end

  def two_of_a_kind
    same_kind
    @pairs
  end

  def two_pair
    same_kind
    if @pairs.size == 2
      numbers = Array.new
      @pairs.each do |number, pair|
        numbers << translate_card(number) + 's' unless number == 6
        numbers << translate_card(number) + 'es' if number == 6
      end
      @rank_string = 'Two Pair ' + numbers.first + ' and ' + numbers.last
      return true
    end
    false
  end

  def one_pair
    same_kind
    if @pairs.size == 1
      @rank_string = 'Pair of ' + translate_card(@pairs.keys.first) + 's' unless @pairs.keys.first == 6
      @rank_string = 'Pair of ' + translate_card(@pairs.keys.first) + 'es' if @pairs.keys.first == 6
      return true
    end
    false
  end

  def three_of_a_kind
    same_kind
    @threes
  end

  def four_of_a_kind
    same_kind
    @fours
  end

  def straight
    c = @hand.group_by { |k| k[:card] }
    sorted = c.keys.uniq.sort
    if sorted.length < 5
      # cant form a straight with duplicates
      @straight = false
    else
      # Ace also has a value of 1, if we start at 2 then we only need 3 more to complete straight.
      if (sorted[4] == 14 && sorted.first == 2)
        @straight = sorted.first + 3 == sorted[3]
      else
        @straight = sorted.first + 4 == sorted.last
      end
    end
    @straight
  end

  def flush
    @flush = @hand.group_by { |h| h[:suit] }.values.select { |a| a.size == 5 }.flatten
    @flush = false if @flush.empty?
  end

  def full_house
    @full_house = (@pairs.size == 1 && @threes)
  end

  def straight_flush
    @straight_flush = (straight && flush)
  end

  def royal_flush
    @royal_flush = (straight && flush && high_card == 14)
  end

  private

  def translate_suit(c)
    t = {'H' => 'Hearts','D' => 'Diamonds','C' => 'Clubs','S' => 'Spades'}
    t[c]
  end

  def translate_card(c)
    t = {2 => 'Two', 3 => 'Three', 4 => 'Four', 5 => 'Five', 6 => 'Six', 7 => 'Seven', 8 => 'Eight', 9 => 'Nine',
         10 => 'Ten', 11 => 'Jack', 12 => 'Queen', 13 => 'King', 14 => 'Ace'}
    t[c]
  end

  def rank_of_cards
    ['straight_flush', 'four_of_a_kind', 'full_house', 'flush', 'straight', 'three_of_a_kind', 'two_pair', 'one_pair']
  end

  def translate_rank(s)
    t = {'royal_flush' => 'Royal Flush', 'straight_flush' => 'Straight Flush', 'four_of_a_kind' => 'Four Of A Kind',
         'full_house' => 'Full House', 'flush' => 'Flush', 'straight' => 'Straight', 'three_of_a_kind' => 'Three Of A Kind',
         'two_pair' => 'Two Pair', 'one_pair' => 'One Pair'}
    t[s]
  end

  def translate_pair(p)
    'Pair of ' + translate_card(p) + 's'
  end
end