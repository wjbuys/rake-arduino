module Rake
  module Arduino
    class Board
      attr_accessor :name
      attr_accessor :cores, :defines
      attr_accessor :mcu, :cpu_speed
      attr_accessor :max_size

      def self.[](name)
        BOARDS[name]
      end

      def initialize(name)
        self.name = name
        self.defines = []

        yield self if block_given?
      end

      BOARDS = {
        "Arduino" => Board.new("Arduino") do |b|
          b.cores = ["arduino"]
          b.cpu_speed = 16000000
          b.mcu = "atmega328p"
          b.max_size = 30720
        end,

        "Teensy 2.0" => Board.new("Teensy 2.0") do |b|
          b.cores = ["teensy", "usb_serial"]
          b.defines = ["USB_SERIAL"]
          b.cpu_speed = 16000000
          b.mcu = "atmega32u4"
          b.max_size = 32256
        end
      }
    end
  end
end
