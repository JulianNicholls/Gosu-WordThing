#! /usr/bin/env ruby

require 'gosu_enhanced'

require './constants'
require './resources'
require './wordgrid'
require './wordlist'
require './gameover'
require './button'
require './pos_handler'

module WordThing
  class Word < Struct.new( :word, :score )
  end
  
  # Word game thing
  class Game < Gosu::Window
    include Constants

    attr_reader :fonts, :images, :list

    KEY_FUNCS = {
      Gosu::KbEscape  =>  -> { @grid.reset_word
                               close if @debug || @game_over },
      Gosu::KbR       =>  -> { reset if @game_over },
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
      add_enter_button
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
      @end        = @elapsed + TIME_LIMIT
      @score      = 0
      @words      = @grid.words.map { |w| Word.new( w, 0 ) }

      set_position_handlers
    end

    def set_position_handlers
      @pos_handlers = PositionHandlers.new
      @pos_handlers.add @grid, :toggle_select
      @pos_handlers.add @enter, :press
    end

    def update
      update_game_over

      @elapsed = Time.now unless @game_over

      @pos_handlers.pass @position
      @position = nil
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

      @enter.draw

      GameOverWindow.new( self ).draw if @game_over
    end

    def button_down( btn_id )
      instance_exec( &KEY_FUNCS[btn_id] ) if KEY_FUNCS.key? btn_id
    end

    def total_score
      @words.reduce( 0 ) { |a, e| a + e.score }
    end

    def add_word
      word = @grid.word

      @words.each do |w|
        if w.word == word
          w.score = word_score( word )
          ok_word
          return
        end
      end
      
      if @list.include? word
        @words << Word.new( word, word_score( word ) + 3 * word.size )
        ok_word
      else
        @sounds[:uhuh].play
      end
    end

    private

    def ok_word
      @grid.reset_word
      @sounds[:ok].play      
    end
    
    def add_enter_button
      font  = @fonts[:word]
      text  = 'ENTER'
      size  = font.measure( text ).inflate( 10, 10 )
      pos   = WORDLIST_POS.offset( WORDLIST_SIZE ).offset(
                -(size.width + 5), -(size.height + 5) )
      @enter = Button.new( self, pos, size, text, Gosu::Color::WHITE, BLUE ) do
        @window.add_word
      end
    end

    def draw_background
      @images[:background].draw( 0, 0, 0 )
    end

    def draw_words
      font  = @words.size < 25 ? @fonts[:word] : @fonts[:word_small] 
      pos   = WORDLIST_POS.offset( 5, 5 )

      @words.each do |w|
        font.draw( w.word, pos.x, pos.y, 1, 1, 1, BLUE )
        render_score( w.score, pos.y, BLUE ) if w.score != 0
        pos.move_by!( 0, (7 * font.height) / 6 )
      end

      if total_score != 0
        pos.move_by!( 0, font.height / 6 )
        font.draw( 'Total', pos.x, pos.y, 1, 1, 1, Gosu::Color::BLACK )
        render_score( total_score, pos.y, Gosu::Color::BLACK )
      end
    end

    def render_score( score, top, colour )
      font  = @words.size < 25 ? @fonts[:word] : @fonts[:word_small] 
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
      font    = @fonts[:time]
      left    = (@end - @elapsed).round
      colour  = BLUE

      if left <= 10
        if @prev_left != left
          @sounds[:blip].play
          @prev_left = left
        end
        
        colour = RED
      end
      
      text  = format( 'Time  %d:%02d', left / 60, left % 60 )
      size  = font.measure( text )
      left  = WIDTH - (GAME_BORDER * 4) - size.width

      font.draw( text, left, GAME_BORDER + 7, 4, 1, 1, colour )
    end

    def word_score( word )
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
