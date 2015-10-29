class Redactor
  class DSL
    attr_reader :redactor

    def initialize(redactor)
      @redactor = redactor
    end

    def rule(reason, regex = nil, &block)
      rule = Rule.new(reason, regex, &block)
      redactor.register_rule(rule)
    end

    def self.run(redactor, block)
      new(redactor).instance_eval(&block)
    end
  end
end
