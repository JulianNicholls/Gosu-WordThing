require './wordgrid'

module WordThing
  class WordGrid
    # Insert random words and letters into a grid
    class Inserter
      # These weightings are based on an analysis of new wtwords.txt

      CONS    = 'BBBCCCCCCDDDDDDFFGGGGGHHHHJKKLLLLLLLLMMMMNNNNNNNNNNN' \
                'PPPPPQRRRRRRRRRRRRSSSSSSSSSSSSSSTTTTTTTTTTVVWWXYYYZ'
      VOWELS  = 'AAAAAAAAAAEEEEEEEEEEEEEEEEIIIIIIIIIIIOOOOOOOOUUUUU'

      def initialize(grid, wordlist)
        @grid = grid
        @list = wordlist
      end

      def fill_random
        @grid.each { |cell| cell[:letter] = random_letter if cell[:letter].empty? }
      end

      def add_word(len)
        loop do
          inserted = select_word(len)
          return inserted if insert_word(inserted)
        end
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
        pos     = GPoint.new(rand(@grid.columns), rand(@grid.rows))
        neighs  = @grid.neighbours(pos)
        poss    = []

        until poss.size == word.size
          ltr = @grid.cell_at(pos)[:letter]

          if ltr.empty? || ltr == word[poss.size]
            poss << pos
            neighs = @grid.neighbours(pos) - poss
          end

          return false if neighs.size == 0
          pos = neighs.pop
        end

        poss.each_with_index { |p, i| @grid.cell_at(p)[:letter] = word[i] }

        true
      end

      # 63% consonant, 37% vowel with the weightings above

      def random_letter
        rand(100) < 63 ? CONS[rand CONS.size] : VOWELS[rand VOWELS.size]
      end
    end
  end
end
