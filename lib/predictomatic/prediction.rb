require 'benchmark'

module Predictomatic
  class Prediction

    attr_reader   :timing
    attr_accessor :examples, :model, :options, :verbose

    def initialize(examples, options)
      @examples = examples
      @options  = options
    end

    def predict
      @timing = Benchmark.realtime do
        @raw_result = command.popen do |io|
          io.puts(examples.join("\n"))
        end
      end

      result
    end

    def result
      decode(@raw_result)
    end

    def command
      command = Command.new('/dev/stdin', default_options.merge!(options))
      command.verbose = verbose
      command
    end

    def decode(result)
      result.split("\n").map! do |result|
        value, label = result.split
        { :label => label, :value => value.to_f }
      end
    end

    def default_options
      { :initial_regressor => model.filename, :testonly => true, :predictions => '/dev/stdout', :quiet => true }
    end

  end
end
