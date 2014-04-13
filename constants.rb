module WordThing
  # Constants for the Tetris Game
  module Constants
    include GosuEnhanced

    GAME_BORDER     = 5
    COLUMNS         = 10
    ROWS            = 10
    TILE_SIZE       = 60
    HEADER_HEIGHT   = 40
    WORDLIST_POS    = Point.new( GAME_BORDER * 2 + COLUMNS * TILE_SIZE,
                                 GAME_BORDER * 2 + HEADER_HEIGHT )

    WORDLIST_SIZE   = Size.new( 180, ROWS * TILE_SIZE )
    
    GRID_ORIGIN   = Point.new( GAME_BORDER, GAME_BORDER * 2 + HEADER_HEIGHT )

    WIDTH         = GAME_BORDER * 3 + COLUMNS * TILE_SIZE + WORDLIST_SIZE.width
    HEIGHT        = GAME_BORDER * 3 + ROWS * TILE_SIZE + HEADER_HEIGHT

    CYAN          = Gosu::Color.new( 0xff, 0x00, 0xb0, 0xb0 )
    BLUE          = Gosu::Color.new( 0xff, 0x00, 0x00, 0xc8 )
    RED           = Gosu::Color.new( 0xff, 0xd0, 0x00, 0x00 )

    SCORES        = { b: 3, c: 3, d: 2, f: 4, g: 2, h: 4, j: 8, k: 5,
                      m: 3, p: 3, q: 10, v: 4, w: 4, x: 8, y: 4, z: 10 }
  end
end
