module Rake
  module Arduino
    class Config
      attr_accessor :home, :hardware_path, :library_path
      attr_accessor :cores

      def initialize
        yield self if block_given?

        self.home ||= ENV["HOME"] + "/apps/arduino"

        self.hardware_path ||= home + "/hardware"
        self.library_path ||= home + "/libraries"

        self.cores ||= Dir.glob(hardware_path + "/**/cores/*")
      end
    end

    class << self
      def config
        @config ||= Config.new
      end

      def configure(&block)
        @config = Config.new(&block)
      end
    end
  end
end
