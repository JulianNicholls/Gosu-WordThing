require './constants'

module WordThing
  # Letter Grid
  class Grid
    include Constants

    attr_reader :word

    # These weightings are based on an analysis of wtwords.txt

    CONS    = 'BBBCCCCCCCDDDDDFFGGGGHHHHJKKLLLLLLLLMMMMMNNNNNNNNNNN' \
              'PPPPPQRRRRRRRRRRRSSSSSSSSSSSSSSSTTTTTTTTTTTTTTTVVWXYYYZ'
    VOWELS  = 'AAAAAAAAAAAEEEEEEEEEEEEEEEIIIIIIIIIIIIOOOOOOOOOUUUU'

    def initialize( surface, columns = COLUMNS, rows = ROWS )
      @window         = surface
      @columns, @rows = columns, rows

      @grid           = build_grid
      reset_word
    end

    def draw
      @grid.each_with_index do |column, col|
        column.each_with_index { |cell, row| render( Grid::Point.new( col, row ), cell ) }
      end
      
      @word_path.each_with_index do |pos, idx| 
        add_word_index( pos, idx + 1 )
      end
    end

    def toggle_select( position )
      process_selection( Grid::Point.from_point( position ) )
    end
    
    def reset_word
      @word       = ''
      @word_path  = []
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
      
      puts "Word: #{@word}, Path: #{@word_path}"
    end
    
    def build_grid
      @grid = Array.new( @columns ) do
        Array.new( @rows ) { { letter: random_letter, selected: false } }
      end

      post_process
    end

    # 62% consonant, 38% vowel with the weightings above

    def random_letter
      rand( 100 ) < 62 ? CONS[rand CONS.size] : VOWELS[rand VOWELS.size]
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
            cell[:letter] = random_letter
          end
        end
      end
    end

    def neighbours( gpoint )
      neighs = []
      (-1..1).each do |xd|
        (-1..1).each do |yd|
          next if xd == 0 && yd == 0
          neighs << gpoint.offset( xd, yd ) if in_grid( gpoint.col + xd, gpoint.row + yd )
        end
      end

      neighs
    end

    def in_grid( x, y )
      x.between?( 0, @columns - 1 ) && y.between?( 0, @rows - 1 )
    end

    def render( gpoint, cell )
      font      = @window.fonts[:letter]
      ltr_ctr   = font.centred_in( cell[:letter], Size.new( BLOCK_SIZE, BLOCK_SIZE ) )
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
      cell = @grid[gpoint.col][gpoint.row]
    end
    
    # Grid Point
    class Point < Struct.new( :col, :row )
      include Constants
      
      def offset( x, y )
        Point.new( col + x, row + y )
      end
      
      def to_point
        GRID_ORIGIN.offset( col * BLOCK_SIZE, row * BLOCK_SIZE )
      end
      
      def self.from_point( pos )
        Point.new( 
          ((pos.x - GRID_ORIGIN.x) / BLOCK_SIZE).floor,
          ((pos.y - GRID_ORIGIN.y) / BLOCK_SIZE).floor
        )
      end
    end
  end
end
