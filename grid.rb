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
      
      post_process
    end

    # A biased set of random letters
    # 60% consonant, 40% vowel
    # E > A > O > I > U
    # T > NRS > HGY >>>> ZXWQ

    def random_letter
      rand( 10 ) < 6 ? CONS[rand CONS.size] : VOWELS[rand VOWELS.size]
    end
    
    def post_process
      add_us_to_qs
    end
    
    def add_us_to_qs
      @grid.each_with_index do |column, col|
        column.each_with_index do |cell, row|
          if cell[:letter] == 'Q'
            cell[:selected] = true
            n = neighbours( col, row )
            unless n.any? { |c, r| @grid[c][r][:letter] == 'U' }
              r = n[rand n.size]
              @grid[r[0]][r[1]][:letter] = 'U'
              @grid[r[0]][r[1]][:selected] = true
            end
          end
        end
      end
    end
    
    def neighbours( x, y )
      neighs = []
      (-1..1).each do |xd|
        (-1..1).each do |yd|
          next if xd == 0 && yd == 0
          neighs << [x + xd, y + yd] if in_grid( x + xd, y + yd )
        end
      end
      
      neighs
    end
    
    def in_grid( x, y )
      x.between?( 0, COLUMNS - 1) && y.between?( 0, ROWS - 1)
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
  end
end
