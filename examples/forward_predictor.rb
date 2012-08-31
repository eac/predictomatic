$: << File.expand_path("../lib")
require 'predictomatic'
require 'yaml'
require 'benchmark'

module Predictomatic
  class ForwardPredictor

    def predict
      build_model
      timing = Benchmark.realtime do
        puts model.predict(questions).inspect
      end

      puts "Predicted in #{timing} seconds"
    end

    def model
      @model ||= Model.new.tap { |model| model.name = 'forward' }
    end

    def build_model
      training_examples = YAML.load_file('forwards.yml').map { |forward| Input::Example.new(forward) }
      model.examples    = training_examples
      model.save
    end

    def questions
     [
       Input::Example.new(
         :label => :yes,
         :features => '---------- Forwarded message ----------
From: Eric Chapweske <eac@example.com>
Date: Tue, Oct 19, 2012 at 3:45 AM
Subject: what is up
To: somebody@somewherelse.example.com'
       ),
       Input::Example.new(
         :label    => :no,
         :features => 'I received a Forwarded Message ---------- it was From: somebody@somewhere.example.com and sent To: me.'
       ),
       Input::Example.new(
         :label    => :no_too_much,
         :features => 'Can you take a look? Thanks.
---------- Forwarded message ----------
From: Eric Chapweske <eac@example.com>
Date: Tue, Oct 19, 2012 at 3:45 AM
Subject: what is up
To: somebody@somewherelse.example.com'
        )
      ]
    end

  end

  ForwardPredictor.new.predict
end
