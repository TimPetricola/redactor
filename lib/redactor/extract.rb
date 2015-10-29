class Redactor
  class Extract
    attr_reader :rule, :value, :start, :finish

    def initialize(rule:, value:, start:, finish:)
      @rule = rule
      @value = value
      @start = start
      @finish = finish
    end

    def reason
      rule.reason
    end

    def collides?(extract)
      [:start, :finish].any? do |m|
        extract.send(m).between?(start, finish)
      end
    end
  end
end
