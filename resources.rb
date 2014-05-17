require 'gosu_enhanced'

module WordThing
  # Resource Loader
  class ResourceLoader
    def self.fonts( window )
      {
        letter:     Gosu::Font.new( window, 'Arial', 30 ),
        word:       Gosu::Font.new( window, 'Arial', 18 ),
        word_small: Gosu::Font.new( window, 'Arial', 15 ),
        button:     Gosu::Font.new( window, 'Arial', 18 ),
        small:      Gosu::Font.new( window, 'Arial', 11 ),
        time:       Gosu::Font.new( window, 'Arial', 25 ),
        header:     Gosu::Font.new( window, 'Arial', 56 ),
        info:       Gosu::Font.new( window, 'Arial', 30 )
      }
    end

    def self.images( window )
      {
        background: Gosu::Image.new( window, 'media/background.png', true ),
        letter:     Gosu::Image.new( window, 'media/letter-bg.png', true ),
        selected:   Gosu::Image.new( window, 'media/letter-selected-bg.png', true )
      }
    end

    def self.sounds( window )
      {
        ok:   Gosu::Sample.new( window, 'media/ok.wav' ),
        uhuh: Gosu::Sample.new( window, 'media/uhuh.wav' ),
        blip: Gosu::Sample.new( window, 'media/blip.wav' )
      }
    end
  end
end
