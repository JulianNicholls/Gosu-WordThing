#! /usr/bin/env ruby

require 'gosu_enhanced'

require './constants'
require './resources'
require './grid'
require './wordlist'

module WordThing
  # Word game thing
  class Game < Gosu::Window
    include Constants

    attr_reader :fonts, :images

    KEY_FUNCS = {
      Gosu::KbEscape =>  -> { close },
      Gosu::KbR      =>  -> { reset },

      Gosu::MsLeft   =>  -> { @position = Point.new( mouse_x, mouse_y ) }
    }

    def initialize( debug, easy )
      super( WIDTH, HEIGHT, false, 200 )

      @fonts  = ResourceLoader.fonts( self )
      @images = ResourceLoader.images( self )
#      @sounds = ResourceLoader.sounds( self )

      @debug  = debug
      @easy   = easy

      self.caption = caption

      @list = WordList.new
      @list.debug
      reset
    end

    def caption
      caption = 'Word Thing'
      caption += ' (Easy)'  if @easy
      caption += ' (Debug)' if @debug

      caption
    end

    def needs_cursor?   # Enable the mouse cursor
      true
    end

    def reset
      @grid       = Grid.new( self )
      @game_over  = false
      @position   = nil
      @moves      = 0
      @start      = Time.now
      @elapsed    = 0
      @score      = 0
    end

    def update
      update_game_over

      @elapsed = (Time.now - @start).round unless @game_over

      unless @position.nil?
        @grid.toggle_select @position
        @position = nil
      end
    end

    def update_game_over
    end

    def draw
      draw_background

      @grid.draw

      draw_loading if @phase == :loading
    end

    def draw_background
      tl    = Point.new( 0, 0 )
      size  = Size.new( WIDTH, HEIGHT )
      draw_rectangle( tl, size, 0, Gosu::Color::WHITE )
      draw_rectangle( tl.offset( 5, 5 ), size.deflate( 10, 10 ), 0, GRID_BG )
    end

    def draw_overlays
      GameOverWindow.new( self ).draw && return if @game_over
    end

    def button_down( btn_id )
      instance_exec( &KEY_FUNCS[btn_id] ) if KEY_FUNCS.has_key? btn_id
    end
  end
end

debug = ARGV.include? '--debug'
easy  = ARGV.include? '--easy'

window = WordThing::Game.new( debug, easy )
window.show
