class Redactor
  DEFAULT_REPLACEMENT = '[REDACTED]'.freeze

  attr_accessor :rules, :default_replacement

  def initialize(rules = [], &block)
    @default_replacement = DEFAULT_REPLACEMENT
    @rules = Array(rules)

    DSL.run(self, block) if block_given?
  end

  def register_rule(rule)
    rules.push(rule)
  end

  # returns a list of Extract objects (including position and value)
  # matching predefined rules
  def extract(from)
    rules.reduce([]) do |extracts, rule|
      new_extracts = rule.extract(from).select do |extract|
        # do not consider new extract if colliding with existing one
        !extracts.any? { |e| e.collides?(extract) }
      end
      extracts.concat(new_extracts)
    end
  end

  # replaces parts of text by [REDACTED]. The replacement string can be
  # customized by passing a block taking the Extract object as an argument
  def format(text, &block)
    extract(text).each_with_object(text.clone) do |extract, redacted_text|
      sub = block_given? ? block.call(extract) : default_replacement
      redacted_text[extract.start...extract.finish] = sub
    end
  end
end

require 'redactor/dsl'
require 'redactor/extract'
require 'redactor/rule'
