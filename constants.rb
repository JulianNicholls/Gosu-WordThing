module FloodPuzzle
  # Constants for the Tetris Game
  module Constants
    GAME_BORDER   = 5
    COLUMNS       = 12
    ROWS          = 12
    BLOCK_SIZE    = 40
    HEADER_HEIGHT = 40

    MARGIN        = 20

    GRID_ORIGIN   = Point.new( GAME_BORDER, GAME_BORDER * 2 + HEADER_HEIGHT )

    WIDTH         = GAME_BORDER * 2 + COLUMNS * BLOCK_SIZE
    HEIGHT        = GAME_BORDER * 3 + HEADER_HEIGHT +
                    ROWS * BLOCK_SIZE + 2 * MARGIN + BLOCK_SIZE

    CYAN          = Gosu::Color.new( 0xff, 0x00, 0xe0, 0xe0 )
    BLUE          = Gosu::Color.new( 0xff, 0x00, 0x00, 0xd0 )
    ORANGE        = Gosu::Color.new( 0xff, 0xe0, 0x90, 0x00 )
    YELLOW        = Gosu::Color.new( 0xff, 0xf0, 0xf0, 0x00 )
    GREEN         = Gosu::Color.new( 0xff, 0x60, 0xe0, 0x00 )
    PURPLE        = Gosu::Color.new( 0xff, 0x80, 0x00, 0x80 )
    RED           = Gosu::Color.new( 0xff, 0xd0, 0x00, 0x00 )

    MOVES_COLOUR  = Gosu::Color.new( 0xff, 0xff, 0xff, 0xff )

    COLOR_TABLE   = [CYAN, ORANGE, BLUE, PURPLE, YELLOW, GREEN]
  end
end
