module Rake
  module Arduino
    class Board
      attr_accessor :name
      attr_accessor :cores, :defines
      attr_accessor :mcu, :cpu_speed
      attr_accessor :max_size

      @boards = {}
      def self.[](name)
        @boards[name]
      end

      def self.register(board)
        @boards[board.name] = board
      end

      def register
        self.class.register(self)
      end

      def initialize(name)
        self.name = name
        self.defines = []
        self.cores = []

        yield self if block_given?
      end
    end

    def self.board(name)
      board = Board[name]
      yield board if block_given?
      board
    end
  end
end
