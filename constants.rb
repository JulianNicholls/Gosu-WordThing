module WordThing
  # Constants for the Tetris Game
  module Constants
    GAME_BORDER   = 5
    COLUMNS       = 12
    ROWS          = 12
    BLOCK_SIZE    = 60

    GRID_ORIGIN   = Point.new( GAME_BORDER, GAME_BORDER )

    WIDTH         = GAME_BORDER * 2 + COLUMNS * BLOCK_SIZE
    HEIGHT        = GAME_BORDER * 2 + ROWS * BLOCK_SIZE

    CYAN          = Gosu::Color.new( 0xff, 0x00, 0xe0, 0xe0 )
    BLUE          = Gosu::Color.new( 0xff, 0x00, 0x00, 0xd0 )
    ORANGE        = Gosu::Color.new( 0xff, 0xe0, 0x90, 0x00 )
    YELLOW        = Gosu::Color.new( 0xff, 0xf0, 0xf0, 0x00 )
    GREEN         = Gosu::Color.new( 0xff, 0x60, 0xe0, 0x00 )
    PURPLE        = Gosu::Color.new( 0xff, 0x80, 0x00, 0x80 )
    RED           = Gosu::Color.new( 0xff, 0xd0, 0x00, 0x00 )

    GRID_BG       = Gosu::Color.new( 0xff, 0x20, 0x20, 0x20 )

    MOVES_COLOUR  = Gosu::Color.new( 0xff, 0xff, 0xff, 0xff )

    COLOR_TABLE   = [CYAN, ORANGE, BLUE, PURPLE, YELLOW, GREEN]

    SCORES        = {
                      b: 3, c: 3, d: 2, f: 4, g: 2, h: 4, j: 8, k: 5,
                      m: 3, p: 3, q: 10, v: 4, w: 4, x: 8, y: 4, z: 10
                    }
  end
end
