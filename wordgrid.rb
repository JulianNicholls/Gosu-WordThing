require './constants'
require './inserter'
require './gridpoint'

module WordThing
  # Letter Grid
  class WordGrid
    include Constants

    attr_reader :words, :word, :columns, :rows

    LENGTHS = [9, 8, 7, 7, 6, 6, 6, 5, 5, 5, 4, 4, 4, 4, 3, 3, 3, 3]

    def initialize( surface, columns = COLUMNS, rows = ROWS )
      @window         = surface
      @columns, @rows = columns, rows
      @region         = Region.new(
                          GRID_ORIGIN, 
                          Size.new( @columns * TILE_SIZE, @rows * TILE_SIZE ) )

      @grid           = new_grid

      @words          = []
      @inserter       = Inserter.new( self, @window.list )
      fill_in_words
#      @inserter.fill_random

      @word, @word_path = '', []
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
      return false unless @region.contains?( position )
      
      process_selection( GPoint.from_point( position ) )
      true    # Handled position
    end

    def reset_word
      @word = ''

      cell_at( @word_path.pop )[:selected] = false while @word_path.size > 0
    end

    def neighbours( gpos )
      neighs = []

      (-1..1).each do |xd|
        (-1..1).each do |yd|
          next if xd == 0 && yd == 0
          pos = gpos.offset( xd, yd )
          neighs << pos if in_grid? pos
        end
      end

      neighs
    end

    def cell_at( gpoint )
      @grid[gpoint.col][gpoint.row]
    end

    def each
      @grid.each do |col|
        col.each { |cell| yield cell }
      end
    end

    private

    def new_grid
      Array.new( @columns ) do
        Array.new( @rows ) { { letter: '', selected: false } }
      end
    end

    def fill_in_words
      LENGTHS.each { |len| @words << @inserter.add_word( len ) }
      puts words
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
          @word.slice!( -1 )
          @word_path.pop
        end
      elsif word.size == 0 || neighbours( @word_path[-1] ).include?( gpoint )
        cell[:selected] = true
        @word << cell[:letter]
        @word_path << gpoint
      end
    end

    def in_grid?( x, y = nil )
      if x.respond_to? :col
        x.col.between?( 0, @columns - 1 ) && x.row.between?( 0, @rows - 1 )
      else
        x.between?( 0, @columns - 1 ) && y.between?( 0, @rows - 1 )
      end
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
  end
end
