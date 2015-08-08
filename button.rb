module WordThing
  # UI Button that calls a passed block when press is called with a position
  # inside the button region.
  class Button
    include GosuEnhanced

    def initialize(surface, region, text, text_clr, bkgr_clr, &press_block)
      @window   = surface
      @region   = region
      @caption  = text
      @text     = text_clr
      @bkgr     = bkgr_clr
      @block    = press_block
    end

    def draw
      @region.draw(@window, 2, @bkgr)

      font = @window.fonts[:button]
      pos  = @region.position.offset(font.centred_in(@caption, @region.size))
      font.draw(@caption, pos.x, pos.y, 2, 1, 1, @text)
    end

    def press(pos)
      return false unless @region.contains? pos

      instance_eval(&@block)
    end
  end
end
