module WordThing
  class Button
    include GosuEnhanced
    
    def initialize( surface, position, size, text, text_colour, bkgr_colour, &press_block )
      @window   = surface
      @region   = Region.new( position, size )
      @caption  = text
      @text     = text_colour
      @bkgr     = bkgr_colour
      @block    = press_block
    end
    
    def draw
      @region.draw( @window, 2, @bkgr )
      font = @window.fonts[:button]
      pos  = @region.position.offset( font.centred_in( @caption, @region.size ) )
      font.draw( @caption, pos.x, pos.y, 2, 1, 1, @text )
    end
    
    def press( pos )
      return false unless @region.contains? pos
      
      instance_eval( &@block )
    end
  end
end
