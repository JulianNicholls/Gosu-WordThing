require './constants'

module WordThing
  # Letter Grid
  class Grid
    include Constants

    attr_accessor :word

    # These weightings are based on an analysis of wtwords.txt

    CONS    = 'BBBCCCCCCCDDDDDFFGGGGHHHHJKKLLLLLLLLMMMMMNNNNNNNNNNN' \
              'PPPPPQRRRRRRRRRRRSSSSSSSSSSSSSSSTTTTTTTTTTTTTTTVVWXYYYZ'
    VOWELS  = 'AAAAAAAAAAAEEEEEEEEEEEEEEEIIIIIIIIIIIIOOOOOOOOOUUUU'

    def initialize( surface, columns = COLUMNS, rows = ROWS )
      @window         = surface
      @columns, @rows = columns, rows

      @grid           = build_grid
      @word           = ''
    end

    def draw
      @grid.each_with_index do |column, col|
        column.each_with_index { |cell, row| render( col, row, cell ) }
      end
    end

    def toggle_select( position )
      column  = (position.x - GRID_ORIGIN.x) / BLOCK_SIZE
      row     = (position.y - GRID_ORIGIN.y) / BLOCK_SIZE

      process_selection( column, row )
    end

    private

    def process_selection( col, row )
      cell = @grid[col][row]
      if cell[:selected]
        cell[:selected] = false
        @word.pop if @word.size > 0 && @word[-1] == cell[:letter]
      else
        cell[:selected] = true
        @word << cell[:letter]
      end
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
            n = neighbours( col, row )
            unless n.any? { |c, r| @grid[c][r][:letter] == 'U' }
              r = n[rand n.size]
              @grid[r[0]][r[1]][:letter] = 'U'
            end
          end
        end
      end
    end

    def change_triples
      @grid.each_with_index do |column, col|
        column.each_with_index do |cell, row|
          n = neighbours( col, row )

          if n.select { |c, r| @grid[c][r][:letter] == cell[:letter] }.size > 1
            cell[:letter] = random_letter
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
      ltr_ctr   = font.centred_in( cell[:letter], Size.new( BLOCK_SIZE, BLOCK_SIZE ) )
      point     = GRID_ORIGIN.offset( col * BLOCK_SIZE, row * BLOCK_SIZE )
      ltr_point = point.offset( ltr_ctr )

      background_image( cell ).draw( point.x, point.y, 1 )
      font.draw( cell[:letter], ltr_point.x, ltr_point.y, 2, 1, 1, BLUE )
    end

    def background_image( cell )
      cell[:selected] ? @window.images[:selected] : @window.images[:letter]
    end
  end
end
