module WordThing
  # Constants for the Tetris Game
  module Constants
    include GosuEnhanced

    GAME_BORDER     = 5
    GRID_BLOCKS     = 10    # Grid space is 10 tiles wide and high
    COLUMNS         = 9
    ROWS            = 9
    TILE_SIZE       = 50
    HEADER_HEIGHT   = 40

    WIDTH           = 795 # GAME_BORDER * 3 + GRID_BLOCKS * TILE_SIZE + WORDLIST_SIZE.width
    HEIGHT          = 655 # GAME_BORDER * 3 + GRID_BLOCKS * TILE_SIZE + HEADER_HEIGHT
                  
    WORDLIST_SIZE   = Size.new( 180, 600 ) # GRID_BLOCKS * TILE_SIZE

    WORDLIST_POS    = Point.new( WIDTH - GAME_BORDER - WORDLIST_SIZE.width,
                                 GAME_BORDER * 2 + HEADER_HEIGHT )

    GRID_ORIGIN     = Point.new( GAME_BORDER + TILE_SIZE / 2, 
                                 GAME_BORDER * 2 + HEADER_HEIGHT + TILE_SIZE / 2 )
                  
    CYAN            = Gosu::Color.new( 0xff, 0x00, 0xa0, 0xa0 )
    BLUE            = Gosu::Color.new( 0xff, 0x00, 0x00, 0xc8 )
    RED             = Gosu::Color.new( 0xff, 0xd0, 0x00, 0x00 )
                  
    SCORES          = { b: 3, c: 3, d: 2, f: 4, 
                        g: 2, h: 4, j: 8, k: 5,
                        m: 3, p: 3, q: 10, v: 4, 
                        w: 4, x: 8, y: 4, z: 10 }
                      
    TIME_LIMIT      = 5 * 60
  end
end
