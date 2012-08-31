module Predictomatic::Input
  # Supports named and anonymous features.
  # named       = Example.new(:features => { :price => '.53', :sqft => '.19', :age => '.30', 1954 => nil })
  # anonymous   = Example.new(:features => [ 'a', 'bunch', 'of', 'words' ])
  # https://github.com/JohnLangford/vowpal_wabbit/wiki/Input-format
  class Example

    attr_accessor :score, :importance, :label, :features

    def initialize(options)
      @score      = options[:score]      || 1
      @importance = options[:importance] || 1.0
      @label      = options[:label]
      @features   = options[:features]
    end

    def to_s
      featured = features
      featured.first.namespace = nil # nasty hack until I can figure out how to specify namespaces for the first feature group
      "#{prefix}#{featured.join(' ')}"
    end

    def features
      if @features.is_a?(String)
        Paragraph.new(@features).features
      else
        @features
      end
    end

    def prefix
      prefix = [ score, importance, vowpal_label ].compact.join(' ')
      prefix = "#{prefix}| " unless prefix.empty?
      prefix
    end

    def vowpal_label
      "'#{label}" if label
    end

  end
end
