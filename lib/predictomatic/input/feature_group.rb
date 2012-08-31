module Predictomatic::Input
  class FeatureGroup

    attr_accessor :namespace, :features

    def initialize(namespace)
      @namespace = namespace
    end

    def features
      @features ||= []
    end

    def to_s
      string = ''
      string << "|#{namespace} " if namespace
      string << features.join(' ')
    end

  end
end
