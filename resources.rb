# Resource Loader

module FloodPuzzle
  # Resource Loader
  class ResourceLoader
    def self.fonts( window )
      filename = 'media/good_times_rg.ttf'

      if File.readable? filename
        load_font( window, filename )
      else
        { button: Gosu::Font.new( window, 'Arial', 14 ),
          moves:  Gosu::Font.new( window, 'Arial', 24 ),
          header: Gosu::Font.new( window, 'Arial', 56 ),
          info:   Gosu::Font.new( window, 'Arial', 30 )  }
      end
    end

    def self.load_font( window, filename )
      {
        button: Gosu::Font.new( window, filename, 14 ),
        moves:  Gosu::Font.new( window, filename, 24 ),
        header: Gosu::Font.new( window, filename, 56 ),
        info:   Gosu::Font.new( window, filename, 30 )
      }
    end

    def self.images( window )
      {
        background: Gosu::Image.new( window, 'media/background.png', true )
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
