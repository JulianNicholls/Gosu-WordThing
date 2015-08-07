require 'gosu_enhanced'

require './constants'

module WordThing
  # Draw parts of the game
  class Drawer
    include Constants

    def initialize(game)
      @game = game
    end

    def words(list)
      font  = list.size < 25 ? @game.fonts[:word] : @game.fonts[:word_small]
      pos   = WORDLIST_POS.offset(5, 5)

      list.each do |w|
        font.draw(w.word, pos.x, pos.y, 1, 1, 1, BLUE)
        render_score(w.score, pos.y, font, BLUE) if w.score != 0
        pos.move_by!(0, (7 * font.height) / 6)
      end

      total_score(pos, font) if @game.total_score != 0
    end

    def current(word)
      font    = @game.fonts[:word]
      pos     = WORDLIST_POS.offset(5, WORDLIST_SIZE.height - (font.height + 5))
      colour  = @game.list.include?(word) ? CYAN : RED

      font.draw(word, pos.x, pos.y, 1, 1, 1, colour)
    end

    private

    def total_score(pos, font)
      pos.move_by!(0, font.height / 6)
      font.draw('Total', pos.x, pos.y, 1, 1, 1, TOTAL_COLOUR)
      render_score(@game.total_score, pos.y, font, TOTAL_COLOUR)
    end

    def render_score(score, top, font, colour)
      score = score.to_s
      left  = WORDLIST_POS.x + (WORDLIST_SIZE.width - 10) -
              font.text_width(score, 1)

      font.draw(score, left, top, 1, 1, 1, colour)
    end
  end
end
