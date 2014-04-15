require './wordgrid'

module WordThing
  class WordGrid
    class Inserter
      # These weightings are based on an analysis of new wtwords.txt

      CONS    = 'BBBCCCCCCDDDDDDFFGGGGGHHHHJKKLLLLLLLLMMMMNNNNNNNNNNN' \
                'PPPPPQRRRRRRRRRRRRSSSSSSSSSSSSSSTTTTTTTTTTVVWWXYYYZ'
      VOWELS  = 'AAAAAAAAAAEEEEEEEEEEEEEEEEIIIIIIIIIIIOOOOOOOOUUUUU'

      def initialize( grid, wordlist )
        @grid, @list = grid, wordlist
      end

      def fill_random
        @grid.each { |cell| cell[:letter] = random_letter if cell[:letter].empty? }
      end

      def add_word( len )
        loop do
          break if insert_word( select_word( len ) )
        end
      end

      private

      def select_word( len )
        word = ''

        while word.empty?
          words = @list.words( ('A'.ord + rand( 26 )).chr, len )
          word  = words[rand words.size].dup unless words.empty?
        end

        word
      end

      def insert_word( word )
        pos     = GPoint.new( rand( @grid.columns ), rand( @grid.rows ) )
        neighs  = @grid.neighbours( pos )
        idx     = 0
        poss    = []

        until idx == word.size
          c = @grid.cell_at pos
          if c[:letter].empty? || c[:letter] == word[idx]
            poss << pos
            idx += 1
            neighs = @grid.neighbours( pos ) - poss
          end

          return false if neighs.size == 0
          pos = neighs.pop
        end

        poss.each_with_index { |p, idx| @grid.cell_at( p )[:letter] = word[idx] }

        true
      end

      # 63% consonant, 37% vowel with the weightings above

      def random_letter
        rand( 100 ) < 63 ? CONS[rand CONS.size] : VOWELS[rand VOWELS.size]
      end
    end
  end
end