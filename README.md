ABANDONED
=========
If you want a mature embedded build tool, check out [PlatformIO](https://platformio.org/) instead.

rake-arduino
============
_A Flexible build tool for Arduino development_

## Usage
_`rake-arduino` is very pre-alpha at the moment. Be prepared to find and fix a
lot of bugs while using it._

After installing the gem (see below), simply add a Rakefile that looks like
this to the root of your project:

    require 'rubygems'
    require 'rake/arduino'

    Rake::Arduino::Sketch.new do |s|
      s.sources << "MySketch.cpp"
      s.libraries << "Servo"

      s.board = Rake::Arduino::Board["Arduino Uno"]
    end

See the `examples` directory for more advanced usage.

Then, to build your project run:

    rake

To upload it to your arduino:

    rake upload

If your arduino installation is somewhere non-standard, you'll need to
configure that at the top of your Rakefile:

    Rake::Arduino.configure do |c|
      c.home = "/home/me/apps/arduino-0022"
    end

## Installation
You'll need ruby and rubygems installed (use your system's package manager, or
RVM).

As a gem:

    gem install rake-arduino

From source:

    gem install bundler rake

    git clone https://github.com/wjbuys/rake-arduino
    cd rake-arduino
    rake install

## Background
Arduino is great. The arduino IDE: not so great. Once your project moves beyond
a nontrivial size, it's a massive pain to use. Sorry Arduino team, but it's
just painful and ugly (and stupid, if you're used to Vim/Emacs).

At this point all the gurus say: "Just use a `Makefile`!". Unfortunately, this
becomes a very roll-your-own mission (there's no centrally maintained version).

Also, the `Makefile` syntax makes my eyes bleed. Inevitably multiple copies of
the same `Makefile` with minor tweaks will end up around all my projects, because
I'm lazy.

*Luckily, there's a solution: _Rake_.* Rake is Ruby, so

1. the syntax is gorgeous,
1. you get a real programming language to do additional pre-processing,
1. and you can wrap common logic up neatly into a central library.

## TODO

1. Support `.pde` sketch pre-processing
1. Add some specs (I just ripped this out of a project I was working on, so no
   tests :( )
1. Support config from ~/.rake-arduino
