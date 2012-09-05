module Predictomatic

  # Generates and persists a model based on the given examples
  class Model

    attr_accessor :name, :path, :verbose

    def predict(examples, options = {})
      prediction                = Prediction.new(examples, options)
      prediction.verbose        = verbose
      prediction.model_filename = filename

      prediction.predict
    end

    def train(examples, options = {})
      training                = Training.new(examples, options)
      training.verbose        = verbose
      training.model_filename = filename
      training.train
    end

    def filename
      "#{path}/#{name}.model"
    end

  end
end
