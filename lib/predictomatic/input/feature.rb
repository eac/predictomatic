module Predictomatic::Input
  class Feature

    attr_reader :name, :value

    def initialize(name, value = nil)
      @name  = name
      @value = value
    end

    def to_s
      [ escaped_name, value ].compact.join(':')
    end

    def escaped_name
      name.to_s.gsub(':', 'X')
    end

  end
end
