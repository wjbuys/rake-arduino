module Rake
  module Arduino
    class Toolchain
      include FileUtils

      attr_accessor :sketch

      def initialize(sketch)
        self.sketch = sketch
      end

      def mcu
        sketch.board.mcu
      end

      def cpp_flags
        [
          "-Wall",
          "-std=gnu++0x",
          "-g",
          "-Os",
          "-w",
          "-fno-exceptions",
          "-ffunction-sections",
          "-fdata-sections",
          "-mmcu=#{mcu}",
          *sketch.defines.map{|d| "-D#{d}"},
          *sketch.includes.map{|i| "-I'#{i}'"}
        ]
      end

      def ld_flags
        ["-Os", "-Wl,--gc-sections", "-mmcu=#{mcu}"]
      end

      def ar_flags
        ['rcs']
      end

      def compile(source_file, options = {})
        object_file = options[:into]
        sh "avr-gcc #{cpp_flags.join(" ")} -c #{source_file} -o #{object_file}"
      end

      def link(main_objects, options)
        compiled_libraries = options[:with]
        binary = options[:into]
        sh "avr-gcc #{ld_flags.join(" ")} #{main_objects.join(" ")} #{compiled_libraries.join(" ")} -lm -o #{binary}"
      end

      def archive(object_file, options = {})
        archive = options[:into]
        sh "avr-ar #{ar_flags.join(" ")} #{archive} #{object_file}"
      end

      def convert_binary(binary, options)
        hex = options[:hex]
        sh "avr-objcopy -O ihex -R .eeprom #{binary} #{hex}"

        `avr-size -A --mcu=#{mcu} #{hex}` =~ /Total(\s*)(\d*)/
        $2.to_i
      end
    end
  end
end
