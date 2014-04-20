#! /usr/bin/env ruby

# puts "FILE: #{__FILE__}"
lib = File.expand_path('../..', __FILE__)   # Seems wrong to me
# puts "lib: #{lib}"
# puts "LP before:", $LOAD_PATH
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
#puts "LP After:", $LOAD_PATH

require 'gosu_enhanced'

require 'constants'

class ConstantViewer
  def initialize
    @wc = WordThing::Constants
    @values, @objects = @wc.constants.partition { |c| const( c ).is_a? Fixnum }
  end

  def show_values
    printf "%25s\n", 'VALUES'
    @values.sort.each { |v| printf( "%-20s %d\n", v, const( v ) ) }
  end

  def show_others
    printf "\n%25s\n", 'OTHERS'
    @objects.sort.each { |v| printf( "%-20s %s\n", v, const( v ) ) }
  end
  
  private
  
  def const( name )
    @wc.const_get name
  end
end

cv = ConstantViewer.new
cv.show_values
cv.show_others