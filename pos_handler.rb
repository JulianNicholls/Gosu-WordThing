require 'pp'

module WordThing
  # Holds a list of mouse position handlers.
  # I'm not sure I'm entirely happy with this yet
  class PositionHandlers
    def initialize(&block)
      @list = []
      instance_eval(&block) if block_given?
    end

    def add(object, method)
      @list << [object, method]
    end

    # Pass the position to each listed object and return when someone
    # has handled it.

    def pass(pos)
      return if pos.nil?

      @list.each do |object, method|
        return if object.__send__(method, pos)
      end
    end
  end
end
