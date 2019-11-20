module WordThing
  # UI Button that calls a passed block when press is called with a position
  # inside the button region.
  class Button
    include GosuEnhanced
    include Constants

    def initialize(surface, region, text, &press_block)
      @window   = surface
      @region   = region
      @caption  = text
      @block    = press_block
    end

    def draw
      @region.draw(@window, 2, BUTTON_BG)

      font = @window.fonts[:button]
      pos  = @region.position.offset(font.centred_in(@caption, @region.size))
      font_text.draw_text(@caption, pos.x, pos.y, 2, 1, 1, BUTTON_TEXT)
    end

    def press(pos)
      return false unless @region.contains? pos

      instance_eval(&@block)
    end
  end
end
