#! /usr/bin/env ruby

require 'gosu_enhanced'

require '../constants'
require '../resources'

module WordThing
  # Word game thing
  class Fonts < Gosu::Window
    include Constants

    KEY_FUNCS = {
      Gosu::KbEscape =>  -> { close }
    }

    def initialize
      super( WIDTH, HEIGHT, false, 200 )

      @fonts  = ResourceLoader.fonts( self )

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
      tl    = Point.new( 0, 0 )
      size  = Size.new( WIDTH, HEIGHT )
      draw_rectangle( tl, size, 0, Gosu::Color::WHITE )
      draw_rectangle( tl.offset( 5, 5 ), size.deflate( 10, 10 ), 0, Gosu::Color::BLACK )
    end

    def draw_fonts
      top = 10

      @fonts.each do |name, font|
        name = name.to_s.upcase
        text = name + ' XXX x XX'
        size = font.measure( text )
        avg  = (size.width / text.size)
        text = format( '%-10s %3d x %2d (%.1f)', name, size.width, size.height, avg )
        font.draw( text, 20, top, 1, 1, 1, Gosu::Color::WHITE )

        top += ((4 * size.height) / 3).floor
      end
    end

    def button_down( btn_id )
      instance_exec( &KEY_FUNCS[btn_id] ) if KEY_FUNCS.key? btn_id
    end

    private

    def arrange_fonts
      @fonts = @fonts.sort_by { |k, v| v.height }
    end
  end
end

WordThing::Fonts.new.show
