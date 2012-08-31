module Predictomatic

  # Predicts an answer for the question using the given model
  class Question

    attr_reader :examples

    def initialize(examples)
      @examples = examples
    end

    def to_s
      examples.join("\n")
    end

  end
end
