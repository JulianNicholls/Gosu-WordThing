require './constants'

module WordThing
  # Letter Grid
  class WordGrid
    include Constants

    attr_reader :word

    LENGTHS = [9, 8, 7, 7, 6, 6, 6, 5, 5, 5, 4, 4, 4, 4, 3, 3, 3, 3]

    def initialize( surface, columns = COLUMNS, rows = ROWS )
      @window         = surface
      @columns, @rows = columns, rows

      @grid           = Builder.new_grid( columns, rows )

      @word       = ''
      @word_path  = []

      fill_in_words
      fill_random
    end

    def draw
      @grid.each_with_index do |col, c|
        col.each_with_index { |cell, r| render( GPoint.new( c, r ), cell ) }
      end

      @word_path.each_with_index do |pos, idx|
        add_word_index( pos, idx + 1 )
      end
    end

    def toggle_select( position )
      process_selection( GPoint.from_point( position ) )
    end

    def reset_word
      @word = ''

      cell_at( @word_path.pop )[:selected] = false while @word_path.size > 0
    end

    private

    def fill_in_words
      LENGTHS.each { |len| add_word( len ) }
    end

    def fill_random
      @grid.each do |col|
        col.each { |cell| cell[:letter] = Builder.random_letter if cell[:letter].empty? }
      end
    end

    def add_word( len )
      loop do
        break if insert_word( select_word( len ) )
      end
    end

    def select_word( len )
      word = ''

      while word.empty?
        words = @window.list.words( ('A'.ord + rand( 26 )).chr, len )
        word  = words[rand words.size].dup unless words.empty?
      end

      word
    end

    def insert_word( word )
      pos     = GPoint.new( rand( @columns ), rand( @rows ) )
      neighs  = neighbours( pos )
      idx     = 0
      poss    = []

      until idx == word.size
        c = cell_at pos
        if c[:letter].empty? || c[:letter] == word[idx]
          poss << pos
          idx += 1
          neighs = neighbours( pos )
        end

        loop do
          return false if neighs.size == 0
          pos = neighs.pop
          break unless poss.include? pos
        end
      end

      poss.each { |p| cell_at( p )[:letter] = word.slice!( 0 ) }

      true
    end

    # process the selection / deselection
    # If there is a word in progress
    #   selection must be of a neighbour of the last letter.
    # deselection must always be of the last letter

    def process_selection( gpoint )
      cell = cell_at( gpoint )

      if cell[:selected]
        if @word_path[-1] == gpoint
          cell[:selected] = false
          @word = @word.slice!( -1 )
          @word_path.pop
        end
      elsif word.size == 0 || neighbours( @word_path[-1] ).include?( gpoint )
        cell[:selected] = true
        @word << cell[:letter]
        @word_path << gpoint
      end
    end

    def neighbours( gpos )
      neighs = []

      (-1..1).each do |xd|
        (-1..1).each do |yd|
          next if xd == 0 && yd == 0
          neighs << gpos.offset( xd, yd ) if in_grid( gpos.col + xd, gpos.row + yd )
        end
      end

      neighs
    end

    def in_grid( x, y )
      x.between?( 0, @columns - 1 ) && y.between?( 0, @rows - 1 )
    end

    def render( gpoint, cell )
      point = gpoint.to_point
      background_image( cell ).draw( point.x, point.y, 1 )

      return if cell[:letter].empty?

      font      = @window.fonts[:letter]
      ltr_ctr   = font.centred_in( cell[:letter], Size.new( TILE_SIZE, TILE_SIZE ) )
      ltr_point = point.offset( ltr_ctr )

      font.draw( cell[:letter], ltr_point.x, ltr_point.y, 2, 1, 1, BLUE )
    end

    def add_word_index( gpoint, widx )
      ltr_pos = gpoint.to_point.offset( 5, 3 )
      @window.fonts[:small].draw( widx.to_s, ltr_pos.x, ltr_pos.y, 2, 1, 1, BLUE )
    end

    def background_image( cell )
      cell[:selected] ? @window.images[:selected] : @window.images[:letter]
    end

    def cell_at( gpoint )
      @grid[gpoint.col][gpoint.row]
    end

    # Grid Point
    class GPoint < Struct.new( :col, :row )
      include Constants

      def offset( x, y )
        GPoint.new( col + x, row + y )
      end

      def to_point
        GRID_ORIGIN.offset( col * TILE_SIZE, row * TILE_SIZE )
      end

      def self.from_point( pos )
        GPoint.new(
          ((pos.x - GRID_ORIGIN.x) / TILE_SIZE).floor,
          ((pos.y - GRID_ORIGIN.y) / TILE_SIZE).floor
        )
      end
    end

    # Grid Builder
    class Builder
      # These weightings are based on an analysis of new wtwords.txt

      CONS    = 'BBBCCCCCCDDDDDDFFGGGGGHHHHJKKLLLLLLLLMMMMNNNNNNNNNNN' \
                'PPPPPQRRRRRRRRRRRRSSSSSSSSSSSSSSTTTTTTTTTTVVWWXYYYZ'
      VOWELS  = 'AAAAAAAAAAEEEEEEEEEEEEEEEEIIIIIIIIIIIOOOOOOOOUUUUU'

      def self.new_grid( columns, rows )
        @grid = Array.new( columns ) do
          Array.new( rows ) { { letter: '', selected: false } }
        end
      end

      # 63% consonant, 37% vowel with the weightings above

      def self.random_letter
        rand( 100 ) < 63 ? CONS[rand CONS.size] : VOWELS[rand VOWELS.size]
      end
    end
  end
end
