$: << File.expand_path("lib")
require 'predictomatic'
require 'yaml'
require 'benchmark'

module Predictomatic

questions = [
  Example.new(
    :label    => :yes,
    :features => '---------- Forwarded message ----------
From: Eric Chapweske <eac@example.com>
Date: Tue, Oct 19, 2012 at 3:45 AM
Subject: what is up
To: somebody@somewherelse.example.com'
  ),
  Example.new(
    :label    => :no,
    :features => 'I received a Forwarded Message ---------- it was From: somebody@somewhere.example.com and sent To: me.'
  ),
  Example.new(
    :label    => :no_too_much,
    :features => 'Can you take a look? Thanks.
---------- Forwarded message ----------
From: Eric Chapweske <eac@example.com>
Date: Tue, Oct 19, 2012 at 3:45 AM
Subject: what is up
To: somebody@somewherelse.example.com'
  )
]

  training_examples = YAML.load_file('forwards.yml').map { |forward| Example.new(forward) }
  model             = Predictomatic::Model.new
  model.examples    = training_examples
  model.name        = 'forward'
  model.save

  question = Predictomatic::Question.new(model.name, questions)

  timing = Benchmark.realtime { puts question.answer(model) }

  puts "Predicted in #{timing} seconds"
end
