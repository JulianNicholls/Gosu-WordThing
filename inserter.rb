require './wordgrid'

module WordThing
  class WordGrid
    # Insert random words and letters into a grid
    class Inserter
      def initialize(grid, wordlist)
        @grid = grid
        @list = wordlist
      end

      def fill_random
        @grid.each(&:randomise)
      end

      def add_word(len)
        inserted = ''

        loop do
          inserted = select_word(len)
          break if insert_word(inserted)
        end

        inserted
      end

      private

      def select_word(len)
        word = ''

        while word.empty?
          words = @list.words(('A'.ord + rand(26)).chr, len)
          word  = words[rand words.size].dup unless words.empty?
        end

        word
      end

      def insert_word(word)
        pos     = random_start_position
        neighs  = @grid.neighbours(pos)
        poss    = []

        until poss.size == word.size
          ltr = @grid.cell_at(pos).letter

          if ltr.empty? || ltr == word[poss.size]
            poss << pos
            neighs = @grid.neighbours(pos) - poss
          end

          return false if neighs.size == 0
          pos = neighs.pop
        end

        poss.each_with_index { |p, i| @grid.cell_at(p).letter = word[i] }

        true
      end

      def random_start_position
        GPoint.new(rand(1...@grid.columns), rand(1...@grid.rows))
      end
    end
  end
end
