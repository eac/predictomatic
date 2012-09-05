module Predictomatic::Input
  class Feature

    attr_reader :name, :value

    def initialize(name, value = nil)
      @name  = name
      @value = value
    end

    def to_s
      pair = [ escaped_name, value ]
      pair.compact!
      pair.join(':')
    end

    def escaped_name
      escaped = name.to_s
      escaped.gsub!(':', 'X')
      escaped
    end

  end
end
