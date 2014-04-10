require './constants'

module WordThing
  # Letter Grid
  class Grid
    include Constants

    CONS    = 'BBCCDDDFFGGGHHHJKKLLMMNNNPPQRRRSSSTTTTVVWXYYZ'
    VOWELS  = 'AAAAEEEEEIIIOOOOUU'  # E5 A4 O$ I3 U2

    def initialize( surface, columns = COLUMNS, rows = ROWS )
      @window         = surface
      @columns, @rows = columns, rows

      @grid = build_grid
    end

    def draw
      @grid.each_with_index do |column, col|
        column.each_with_index { |cell, row| render( col, row, cell ) }
      end
    end

    def render( col, row, cell )
      font      = @window.fonts[:letter]
      size      = font.measure( cell[:letter] )
      image     = cell[:selected] ? @window.images[:selected] : @window.images[:letter]
      point     = GRID_ORIGIN.offset( col * BLOCK_SIZE, row * BLOCK_SIZE )
      ltr_point = point.offset( (BLOCK_SIZE - size.width) / 2, (BLOCK_SIZE - size.height) / 2 )

      image.draw( point.x, point.y, 1 )
      font.draw( cell[:letter], ltr_point.x, ltr_point.y, 2, 1, 1, BLUE )
    end
    
    def toggle_select( position )
      column  = (position.x - GRID_ORIGIN.x) / BLOCK_SIZE
      row     = (position.y - GRID_ORIGIN.y) / BLOCK_SIZE
      
      @grid[column][row][:selected] = !@grid[column][row][:selected]
    end
    
    private

    def build_grid
      @grid = Array.new( @columns ) do
        Array.new( @rows ) do
          {
            letter:   random_letter,
            selected: false
          }
        end
      end
    end

    # A biased set of random letters
    # 60% consonant, 40% vowel
    # E > A > O > I > U
    # T > NRS > HGY >>>> ZXWQ

    def random_letter
      rand( 10 ) < 6 ? CONS[rand CONS.size] : VOWELS[rand VOWELS.size]
    end
  end
end
