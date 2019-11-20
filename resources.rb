require 'gosu_enhanced'

module WordThing
  # Resource Loader
  class ResourceLoader
    def initialize(window)
      @window = window
    end

    def fonts
      {
        letter:     Gosu::Font.new(@window, 'Arial', 30),
        word:       Gosu::Font.new(@window, 'Arial', 18),
        word_small: Gosu::Font.new(@window, 'Arial', 15),
        button:     Gosu::Font.new(@window, 'Arial', 18),
        small:      Gosu::Font.new(@window, 'Arial', 11),
        time:       Gosu::Font.new(@window, 'Arial', 25),
        header:     Gosu::Font.new(@window, 'Arial', 56),
        info:       Gosu::Font.new(@window, 'Arial', 30)
      }
    end

    def images
      {
        background: Gosu::Image.new('media/background.png'),
        letter:     Gosu::Image.new('media/letter-bg.png'),
        selected:   Gosu::Image.new('media/letter-sel-bg.png')
      }
    end

    def sounds
      {
        ok:   Gosu::Sample.new('media/ok.wav'),
        uhuh: Gosu::Sample.new('media/uhuh.wav'),
        blip: Gosu::Sample.new('media/blip.wav')
      }
    end
  end
end
