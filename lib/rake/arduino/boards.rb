module Rake::Arduino
  Board.new("Arduino Uno") do |b|
    b.cores = ["arduino"]
    b.cpu_speed = 16000000
    b.mcu = "atmega328p"
    b.max_size = 30720
  end.register

  Board.new("Teensy 2.0") do |b|
    b.cores = ["teensy", "usb_serial"]
    b.defines = ["USB_SERIAL"]
    b.cpu_speed = 16000000
    b.mcu = "atmega32u4"
    b.max_size = 32256
  end.register
end
