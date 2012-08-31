module Predictomatic
  class Paragraph

    attr_reader :text

    def initialize(text)
      @text = text
    end

    def features
      features = []

      text.each_line.with_index do |line, line_index|
        group  = FeatureGroup.new("L#{line_index}")
        tokens = line.split
        tokens.each do |token|
          group.features << Feature.new(token)
        end

        features << group
      end

      features
    end

  end
end
