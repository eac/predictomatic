module Predictomatic
  class Question

    attr_reader :name, :examples

    def initialize(name, examples)
      @name     = name
      @examples = examples
    end

    def save
      File.open(filename, 'w') do |f|
        examples.each { |example| f.puts(example.to_s) }
      end
    end

    def filename
      "data/#{name}_question.tmp"
    end

  end
end
