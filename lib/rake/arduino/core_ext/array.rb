require 'pathname'

class Array
  def to_paths
    self.map do |path|
      Pathname(path) unless path.is_a? Pathname
    end
  end
end
