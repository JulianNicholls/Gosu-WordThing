#! /usr/bin/env ruby

lib = File.expand_path('../..', __FILE__) # Seems wrong to me
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'gosu_enhanced'

require 'constants'
require 'resources'

module WordThing
  # Word game thing
  class Fonts < Gosu::Window
    include Constants

    KEY_FUNCS = {
      Gosu::KbEscape => -> { close }
    }.freeze

    def initialize
      super(WIDTH, HEIGHT, false, 200)

      @fonts = ResourceLoader.new(self).fonts

      arrange_fonts

      self.caption = caption
    end

    def caption
      'Word Thing Fonts'
    end

    def update
    end

    def draw
      draw_background
      draw_fonts
    end

    def draw_background
      tl    = Point.new(0, 0)
      size  = Size.new(WIDTH, HEIGHT)
      draw_rectangle(tl, size, 0, Gosu::Color::WHITE)
      draw_rectangle(tl.offset(5, 5), size.deflate(10, 10),
                     0, Gosu::Color::BLACK)
    end

    def draw_fonts
      top = 10

      @fonts.each do |name, font|
        size = render(top, name, font)

        top += ((4 * size.height) / 3).floor
      end
    end

    def button_down(btn_id)
      instance_exec(&KEY_FUNCS[btn_id]) if KEY_FUNCS.key? btn_id
    end

    private

    def render(top, name, font)
      name = name.to_s.upcase
      text = name + ' XXX x XX'
      size = font.measure(text)
      text = format('%-10s %3d x %2d (%.1f)',
                    name, size.width, size.height, size.width / text.size)
      font.draw_text(text, 20, top, 1, 1, 1, Gosu::Color::WHITE)

      size
    end

    def arrange_fonts
      @fonts = @fonts.sort_by { |_, v| v.height }
    end
  end
end

WordThing::Fonts.new.show
