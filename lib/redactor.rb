require 'redactor/clear'
require 'redactor/dsl'
require 'redactor/extract'
require 'redactor/rule'

module Redactor
  DEFAULT_REPLACEMENT = '[REDACTED]'.freeze

  class << self
    attr_accessor :rules
    attr_accessor :default_replacement
  end

  self.rules = []
  self.default_replacement = DEFAULT_REPLACEMENT

  def self.define(&block)
    DSL.run(block)
  end

  def self.register_rule(rule)
    rules.push(rule)
  end

  # returns a list of Extract objects (including position and value)
  # matching predefined rules
  def self.extract(from)
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
  def self.format(text, &block)
    extract(text).each_with_object(text.clone) do |extract, redacted_text|
      sub = block_given? ? block.call(extract) : default_replacement
      redacted_text[extract.start...extract.finish] = sub
    end
  end
end
