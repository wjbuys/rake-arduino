require 'rake/arduino/core_ext/pathname'

module Rake
  module Arduino
    class Sketch
      include Rake::DSL

      attr_accessor :main
      attr_accessor :target, :mcu, :cpu_speed
      attr_accessor :libraries
      attr_accessor :hex, :elf
      attr_accessor :programmer, :upload_rate, :max_size
      attr_accessor :usb_type
      attr_accessor :build_root

      def initialize(main)
        main = Pathname(main)

        self.main = main

        self.libraries = []

        yield self

        self.target ||= :arduino
        self.build_root ||= "build/#{target}"
        self.hex ||= main.basename.sub_ext(".hex")
        self.elf ||= build(main.basename.sub_ext(".elf"))

        self.upload_rate ||= 19200
        self.cpu_speed = 16000000
        self.mcu ||= "atmega328p"

        self.max_size ||= 30720

        self.programmer ||= "avr109"

        create_tasks
      end

      def config
        Rake::Arduino.config
      end

      def core_paths
        config.cores.map{|c| Pathname(c)}
      end

      def library_paths
        libraries.map do |lib|
          Pathname(config.library_path) + lib
        end
      end

      def build(path)
        build_path = Pathname(build_root) + path
      end

      def compile(*source_files)
        source_files = [source_files].flatten
        object_files = source_files.map { |source| build(source.sub_ext(".o")) }

        object_files.zip(source_files).each do |object_file, source_file|
          file object_file => source_file do
            object_file.parent.mkpath
            cc "-c", source_file, "-o", object_file
          end
        end

        object_files
      end

      def create_tasks
        compiled_libraries = [
          target,
          *libraries
        ].map{|l| build("#{l}.a")}

        task :default => [*compiled_libraries, hex]

        main_objects = compile main

        (core_paths + library_paths).each do |path|
          library_out = build(path.basename.sub_ext(".a"))

          object_files = compile Pathname.glob(path +"**/*.{c,cpp}")

          file library_out => object_files do
            object_files.each do |object_file|
              library_out.parent.mkpath
              ar library_out, object_file
            end
          end
        end

        file elf => main_objects + compiled_libraries do
          ld main_objects.join(" "), compiled_libraries.join(" "), "-lm", "-o", elf
        end

        file hex => elf do
          objcp elf, hex

          size = hex_size
          if size > max_size
            puts "The sketch size (#{size} bytes) has overriden the maximum size (#{max_size} bytes)."
            rm hex
            exit -1
          else
            puts "Sketch size: #{size} bytes (of a #{max_size} bytes maximum)."
          end
        end

        task :upload => [:all, :upload_pre] do
          sh "#{avrdude} -V -F -p #{mcu} -c #{programmer} -P #{port} -b #{upload_rate} -D -Uflash:w:#{hex}:i"
        end

        task :clean do
          rm_rf Dir["build"]
          rm_f Dir["**/*.{o,a,hex,elf}"]
        end
      end

      def includes
        ["/usr/lib/avr/include/avr", "./include", "lib/#{target}"]
      end

      def defines
        ["F_CPU=#{cpu_speed}L", "ARDUINO=18"]
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
          *defines.map{|d| "-D#{d}"},
          *includes.map{|i| "-I'#{i}'"}
        ]
      end

      def ld_flags
        ["-Os", "-Wl,--gc-sections", "-mmcu=#{mcu}"]
      end

      def ar_flags
        ['rcs']
      end

      def cc(*args)
        sh "avr-gcc #{(cpp_flags + args).join(" ")}"
      end

      def ld(*args)
        sh "avr-gcc #{(ld_flags + args).join(" ")}"
      end

      def ar(*args)
        sh "avr-ar #{(ar_flags + args).join(" ")}"
      end

      def objcp(*args)
        sh "avr-objcopy -O ihex -R .eeprom #{args.join(" ")}"
      end

      def hex_size
        `avr-size -A --mcu=#{mcu} #{hex}` =~ /Total(\s*)(\d*)/
        $2.to_i
      end

      def avrdude
        "avrdude"
      end
    end
  end
end
