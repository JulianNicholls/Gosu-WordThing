module WordThing
  # Grid cell
  class Cell
    # These weightings are based on an analysis of new wtwords.txt

    CONS    = 'BBBCCCCCCDDDDDDFFGGGGGHHHHJKKLLLLLLLLMMMMNNNNNNNNNNN' \
              'PPPPPQRRRRRRRRRRRRSSSSSSSSSSSSSSTTTTTTTTTTVVWWXYYYZ'.freeze
    VOWELS  = 'AAAAAAAAAAEEEEEEEEEEEEEEEEIIIIIIIIIIIOOOOOOOOUUUUU'.freeze

    attr_accessor :letter

    def initialize
      @letter = ''
      @selected = false
    end

    def toggle_selected
      @selected = !@selected
    end

    def empty?
      letter == ''
    end

    def selected?
      @selected
    end

    def randomise
      @letter = random_letter if empty?
    end

    private

    # 63% consonant, 37% vowel with the weightings above

    def random_letter
      rand(100) < 63 ? CONS[rand CONS.size] : VOWELS[rand VOWELS.size]
    end
  end
end
