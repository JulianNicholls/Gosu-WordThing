require './constants'
require './overlaywindow.rb'

module WordThing
  # Show the window when the game is over
  class GameOverWindow < OverlayWindow
    include Constants

    P_ORIGIN  = Point.new( 30, 30 )
    P_SIZE    = Size.new( WIDTH - 60, HEIGHT - 60 )

    def draw
      @window.draw_rectangle( P_ORIGIN, P_SIZE, 10, Gosu::Color::WHITE )

      say( 'GAME OVER', @fonts[:header],
           :center, P_ORIGIN.y + P_SIZE.height / 6, BLUE )

      say( "SCORE: #{score_with_commas}", @fonts[:info],
           :center, P_ORIGIN.y + P_SIZE.height * 2 / 5, RED )

      say( 'Press R to Restart', @fonts[:info],
           :center, P_ORIGIN.y + P_SIZE.height * 3 / 5, BLUE )

      say( 'Press Escape to Exit', @fonts[:info],
           :center, P_ORIGIN.y + P_SIZE.height * 4 / 5, BLUE )
    end

    def score_with_commas
      # Work through, finding...
      # Three digit sections, preceded and followed by at least one digit and...
      # Replace with the digits followed by a comma

      @window.total_score.to_s.gsub( /(\d)(?=(\d{3})+(?!\d))/, '\\1,' )
    end
  end
end
