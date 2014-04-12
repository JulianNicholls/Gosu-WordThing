require 'gosu'

module WordThing
  # Resource Loader
  class ResourceLoader
    def self.fonts( window )
      {
        button: Gosu::Font.new( window, 'Arial', 14 ),
        moves:  Gosu::Font.new( window, 'Arial', 24 ),
        header: Gosu::Font.new( window, 'Arial', 56 ),
        info:   Gosu::Font.new( window, 'Arial', 30 ),
        letter: Gosu::Font.new( window, 'Arial', 30 ),
        small:  Gosu::Font.new( window, 'Arial', 11 ) 
      }
    end

    def self.images( window )
      {
        letter:   Gosu::Image.new( window, 'media/letter-bg.png', true ),
        selected: Gosu::Image.new( window, 'media/letter-selected-bg.png', true )
      }
    end

    def self.sounds( window )
      {
        flip: Gosu::Sample.new( window, 'media/Blip.wav' ),
        tada: [Gosu::Sample.new( window, 'media/tada.wav' ),
               Gosu::Sample.new( window, 'media/alleluia.wav' ),
               Gosu::Sample.new( window, 'media/shazam2.wav' ),
               Gosu::Sample.new( window, 'media/ww_kewl.wav' ),
               Gosu::Sample.new( window, 'media/yeehaw.wav' )]
      }
    end
  end
end
