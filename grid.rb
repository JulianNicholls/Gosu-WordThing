require './constants'

module WordThing
  # Letter Grid
  class Grid
    include Constants

    attr_reader :word

    def initialize( surface, columns = COLUMNS, rows = ROWS )
      @window         = surface
      @columns, @rows = columns, rows

      @grid           = Builder.new_grid( columns, rows )
      post_process

      @word       = ''
      @word_path  = []
    end

    def draw
      @grid.each_with_index do |col, c|
        col.each_with_index { |cell, r| render( Grid::Point.new( c, r ), cell ) }
      end

      @word_path.each_with_index do |pos, idx|
        add_word_index( pos, idx + 1 )
      end
    end

    def toggle_select( position )
      process_selection( Grid::Point.from_point( position ) )
    end

    def reset_word
      @word = ''

      cell_at( @word_path.pop )[:selected] = false while @word_path.size > 0
    end

    private

    # process the selection / deselection
    # If there is a word in progress
    #   selection must be of a neighbour of the last letter.
    # deselection must always be of the last letter

    def process_selection( gpoint )
      cell = cell_at( gpoint )

      if cell[:selected]
        if @word_path[-1] == gpoint
          cell[:selected] = false
          @word = @word[0..-2]
          @word_path.pop
        end
      elsif word.size == 0 || neighbours( gpoint ).include?( @word_path[-1] )
        cell[:selected] = true
        @word << cell[:letter]
        @word_path << gpoint
      end
    end

    def post_process
      add_us_to_qs
      change_triples
    end

    def add_us_to_qs
      @grid.each_with_index do |column, col|
        column.each_with_index do |cell, row|
          if cell[:letter] == 'Q'
            n = neighbours( Grid::Point.new( col, row ) )
            unless n.any? { |gp| cell_at( gp )[:letter] == 'U' }
              r = n[rand n.size]
              cell_at( r )[:letter] = 'U'
            end
          end
        end
      end
    end

    def change_triples
      @grid.each_with_index do |column, col|
        column.each_with_index do |cell, row|
          n = neighbours( Grid::Point.new( col, row ) )

          if n.select { |gp| cell_at( gp )[:letter] == cell[:letter] }.size > 1
            cell[:letter] = Builder.random_letter
          end
        end
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
      font      = @window.fonts[:letter]
      ltr_ctr   = font.centred_in( cell[:letter], Size.new( TILE_SIZE, TILE_SIZE ) )
      point     = gpoint.to_point
      ltr_point = point.offset( ltr_ctr )

      background_image( cell ).draw( point.x, point.y, 1 )
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
    class Point < Struct.new( :col, :row )
      include Constants

      def offset( x, y )
        Point.new( col + x, row + y )
      end

      def to_point
        GRID_ORIGIN.offset( col * TILE_SIZE, row * TILE_SIZE )
      end

      def self.from_point( pos )
        Point.new(
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
          Array.new( rows ) { { letter: random_letter, selected: false } }
        end
      end

      # 63% consonant, 37% vowel with the weightings above

      def self.random_letter
        rand( 100 ) < 63 ? CONS[rand CONS.size] : VOWELS[rand VOWELS.size]
      end
    end
  end
end
