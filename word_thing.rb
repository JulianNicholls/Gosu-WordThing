#! /usr/bin/env ruby

require 'gosu_enhanced'

require './constants'
require './resources'
require './wordgrid'
require './wordlist'
require './gameover'
require './button'
require './pos_handler'
require './drawer'

module WordThing
  # Word storage
  Word = Struct.new(:word, :score)

  # Word game thing
  class Game < Gosu::Window
    include Constants

    attr_reader :fonts, :images, :list

    KEY_FUNCS = {
      Gosu::KbEscape  =>  -> { handle_escape },
      Gosu::KbR       =>  -> { reset if @game_over },
      Gosu::KbReturn  =>  -> { add_word },

      Gosu::MsLeft    =>  -> { @position = Point.new(mouse_x, mouse_y) }
    }

    def initialize(debug)
      super(WIDTH, HEIGHT, false, 100)

      @debug  = debug

      self.caption = caption

      loader = ResourceLoader.new(self)

      @fonts  = loader.fonts
      @images = loader.images
      @sounds = loader.sounds

      @drawer = Drawer.new(self)

      @list   = WordList.new

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
      @grid       = WordGrid.new(self)
      @game_over  = false
      @position   = nil
      @moves      = 0
      @elapsed    = Time.now
      @end        = @elapsed + TIME_LIMIT
      @score      = 0
      @words      = @grid.words.map { |w| Word.new(w, 0) }

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
      @drawer.words(@words)
      @drawer.current(@grid.word) unless @grid.word.empty?
      draw_elapsed

      @enter.draw

      GameOverWindow.new(self).draw if @game_over
    end

    def button_down(btn_id)
      instance_exec(&KEY_FUNCS[btn_id]) if KEY_FUNCS.key? btn_id
    end

    def total_score
      @words.reduce(0) { |a, e| a + e.score }
    end

    def add_word
      word = @grid.word

      @words.each do |w|
        next unless w.word == word

        w.score = word_score(word)
        ok_word
        return
      end

      if @list.include? word
        @words << Word.new(word, word_score(word) + 3 * word.size)
        ok_word
      else
        @sounds[:uhuh].play
      end
    end

    private

    def handle_escape
      @grid.reset_word
      close if @debug || @game_over
    end

    def ok_word
      @grid.reset_word
      @sounds[:ok].play
    end

    def add_enter_button
      font  = @fonts[:word]
      text  = 'ENTER'
      size  = font.measure(text).inflate(10, 10)
      pos   = WORDLIST_POS.offset(WORDLIST_SIZE).offset(
                -(size.width + 5), -(size.height + 5))
      @enter = Button.new(self, pos, size, text, BUTTON_TEXT, BUTTON_BG) do
        @window.add_word
      end
    end

    def draw_background
      @images[:background].draw(0, 0, 0)
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

      text  = format('Time  %d:%02d', left / 60, left % 60)
      size  = font.measure(text)
      left  = WIDTH - (GAME_BORDER * 4) - size.width

      font.draw(text, left, GAME_BORDER + 7, 4, 1, 1, colour)
    end

    def word_score(word)
      total = word.each_char.reduce(0) do |tot, ltr|
        ltr = ltr.downcase.to_sym

        tot + (SCORES.key?(ltr) ? SCORES[ltr] : 1)
      end

      total * [word.size - 4, 1].max
    end
  end
end

debug = ARGV.include? '--debug'

window = WordThing::Game.new(debug)
window.show
