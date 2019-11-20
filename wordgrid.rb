require './constants'
require './inserter'
require './gridpoint'
require './cell'

module WordThing
  # Grid into which words are inserted
  class WordGrid
    include Constants

    attr_reader :words, :word, :columns, :rows

    LENGTHS = [11, 10, 9, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4].freeze

    def initialize(game, columns = COLUMNS, rows = ROWS)
      @game     = game
      @columns  = columns
      @rows     = rows
      @region   = Region.new(
        GRID_ORIGIN,
        Size.new(@columns * TILE_SIZE, @rows * TILE_SIZE)
      )

      initialize_grid

      @word       = ''
      @word_path  = []
    end

    def draw
      @grid.each_with_index do |col, c|
        col.each_with_index { |cell, r| render(GPoint.new(c, r), cell) }
      end
    end

    def toggle_select(position)
      return false unless @region.contains?(position)

      process_selection(GPoint.from_point(position))
      true # Handled position
    end

    def reset_word
      @word = ''

      cell_at(@word_path.pop).toggle_selected until @word_path.empty?
    end

    def neighbours(gpos)
      neighs = []

      (-1..1).each do |xd|
        (-1..1).each do |yd|
          next if xd.zero? && yd.zero?

          pos = gpos.offset(xd, yd)
          neighs << pos if in_grid? pos
        end
      end

      neighs
    end

    def cell_at(gpoint)
      @grid[gpoint.col][gpoint.row]
    end

    def each
      @grid.each { |col| col.each { |cell| yield cell } }
    end

    private

    def initialize_grid
      @grid     = new_grid
      @words    = []
      inserter  = Inserter.new(self, @game.list)

      LENGTHS.each { |len| @words << inserter.add_word(len) }

      inserter.fill_random
    end

    def new_grid
      Array.new(@columns) do
        Array.new(@rows) { Cell.new }
      end
    end

    # process the selection / deselection
    # If there is a word in progress
    #   selection must be of a neighbour of the last letter.
    # deselection must always be of the last letter

    def process_selection(gpoint)
      cell = cell_at(gpoint)

      return unselect_cell(cell) if cell.selected? && @word_path[-1] == gpoint

      select_cell(gpoint, cell) if valid_next(gpoint)
    end

    def valid_next(gpoint)
      @word.empty? ||
        (!@word_path.include?(gpoint) &&
        neighbours(@word_path[-1]).include?(gpoint))
    end

    def select_cell(gpoint, cell)
      cell.toggle_selected
      @word << cell.letter
      @word_path << gpoint
    end

    def unselect_cell(cell)
      cell.toggle_selected
      @word.slice!(-1)
      @word_path.slice!(-1)
    end

    def in_grid?(gpoint)
      gpoint.col.between?(0, @columns - 1) &&
        gpoint.row.between?(0, @rows - 1)
    end

    def render(gpoint, cell)
      point = gpoint.to_point
      background_image(cell).draw(point.x, point.y, 1)

      letter    = cell.letter
      font      = @game.fonts[:letter]
      ltr_ctr   = font.centred_in(letter, Size.new(TILE_SIZE, TILE_SIZE))
      ltr_point = point.offset(ltr_ctr)

      font.draw_text(letter, ltr_point.x, ltr_point.y, 2, 1, 1, BLUE)
    end

    def background_image(cell)
      cell.selected? ? @game.images[:selected] : @game.images[:letter]
    end
  end
end
