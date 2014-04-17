#! /usr/bin/env ruby

require 'gosu_enhanced'

require './constants'
require './resources'
require './wordgrid'
require './wordlist'

module WordThing
  # Word game thing
  class Game < Gosu::Window
    include Constants

    attr_reader :fonts, :images, :list

    KEY_FUNCS = {
      Gosu::KbEscape  =>  -> { @grid.reset_word ; close if @debug },
      Gosu::KbR       =>  -> { reset },
      Gosu::KbReturn  =>  -> { add_word },

      Gosu::MsLeft    =>  -> { @position = Point.new( mouse_x, mouse_y ) }
    }

    def initialize( debug )
      super( WIDTH, HEIGHT, false, 100 )

      @fonts  = ResourceLoader.fonts( self )
      @images = ResourceLoader.images( self )
      @sounds = ResourceLoader.sounds( self )

      @debug  = debug

      self.caption = caption

      @list = WordList.new
      reset
    end

    def caption
      caption = 'Word Thing'
      caption += ' (Debug)' if @debug

      caption
    end

    def needs_cursor?   # Enable the mouse cursor
      true
    end

    def reset
      @grid       = WordGrid.new( self )
      @game_over  = false
      @position   = nil
      @moves      = 0
      @elapsed    = Time.now
      @end        = @elapsed + 120
      @score      = 0
      @words      = []
    end

    def update
      update_game_over

      @elapsed = Time.now unless @game_over

      unless @position.nil?
        @grid.toggle_select @position
        @position = nil
      end
    end

    def update_game_over
      @game_over = @elapsed > @end
    end

    def draw
      draw_background

      @grid.draw
      draw_words
      draw_current_word
      draw_elapsed
    end

    def draw_background
      @images[:background].draw( 0, 0, 0 )
    end

    def draw_words
      total = 0
      font  = @fonts[:word]
      pos   = WORDLIST_POS.offset( 5, 5 )

      @words.each do |w|
        total += w[:score]
        font.draw( w[:word], pos.x, pos.y, 1, 1, 1, BLUE )
        render_score( w[:score], pos.y, BLUE )
        pos.move_by!( 0, (7 * font.height) / 6 )
      end

      if total != 0
        font.draw( 'Total', pos.x, pos.y, 1, 1, 1, Gosu::Color::BLACK )
        render_score( total, pos.y, Gosu::Color::BLACK )
      end
    end

    def render_score( score, top, colour )
      font  = @fonts[:word]
      left  = WORDLIST_POS.x + (WORDLIST_SIZE.width - 10) -
              font.text_width( score.to_s, 1 )
      font.draw( score.to_s, left, top, 1, 1, 1, colour)
    end

    def draw_current_word
      word  = @grid.word

      if word.size > 0
        font    = @fonts[:word]
        pos     = WORDLIST_POS.offset( 5, WORDLIST_SIZE.height - (font.height + 5) )
        colour  = @list.include?( word ) ? CYAN : RED

        font.draw( word, pos.x, pos.y, 1, 1, 1, colour )
      end
    end

    def draw_elapsed
      font = @fonts[:time]
      left = (@end - @elapsed).round
      text = format( 'Time  %d:%02d', left / 60, left % 60 )
      size = font.measure( text )
      left = WIDTH - (GAME_BORDER * 4) - size.width

      font.draw( text, left, GAME_BORDER + 7, 4, 1, 1, BLUE )
    end

    def button_down( btn_id )
      instance_exec( &KEY_FUNCS[btn_id] ) if KEY_FUNCS.key? btn_id
    end

    def add_word
      word = @grid.word

      if @list.include? word
        @words << { word: word, score: score( word ) }
        @grid.reset_word
        @sounds[:ok].play
      else
        @sounds[:uhuh].play
      end
    end

    def score( word )
      total = word.each_char.reduce( 0 ) do |tot, ltr|
        ltr = ltr.downcase.to_sym

        tot + (SCORES.key?( ltr ) ? SCORES[ltr] : 1)
      end

      total * [word.size - 4, 1].max
    end
  end
end

debug = ARGV.include? '--debug'

window = WordThing::Game.new( debug )
window.show
