module Redactor
  class DSL
    def rule(reason, regex = nil, &block)
      rule = Rule.new(reason, regex, &block)
      Redactor.register_rule(rule)
    end

    def self.run(block)
      new.instance_eval(&block)
    end
  end
end
