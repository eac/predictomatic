module Predictomatic

  # Generates and persists a model based on the given examples
  class Model

    attr_accessor :name, :path, :verbose

    def predict(examples, options = {})
      prediction = Prediction.new(examples, options)
      prediction.model   = self
      prediction.verbose = verbose
      prediction.predict
    end

    def train(examples, options = {})
      File.open(example_filename, 'w') do |f|
        examples.each { |example| f.puts(example.to_s)  }
      end
      train_from_examples(training_options.merge!(options))

      File.exist?(filename)
    end

    def filename
      "#{path}/#{name}.model"
    end

    protected

    def train_from_examples(options)
      # Seems like VW uses old cache files when regenerating models
      `rm #{cache_filename}` if File.exist?(cache_filename)

      command = Command.new(example_filename, options)
      command.verbose = verbose
      command.run
    end

    def training_options
      { :cache => true, :passes => 25, :final_regressor => filename, :quiet => true, :ngram => 2, :bit_precision => 22 }
    end

    def cache_filename
      "#{example_filename}.cache"
    end

    def example_filename
      "#{path}/#{name}_dataset.tmp"
    end

  end
end
