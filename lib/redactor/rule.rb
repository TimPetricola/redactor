class Redactor
  class Rule
    attr_reader :reason, :regex, :block

    def initialize(reason, regex = nil, &block)
      if regex && block_given?
        raise ArgumentError, 'cannot have a regex and a block'
      elsif !regex && !block_given?
        raise ArgumentError, 'must have a regex or a block'
      end

      @reason = reason
      @regex = regex
      @block = block
    end

    def extract(input)
      return extract_regex(input) if regex
      return extract_block(input) if block
    end

    private

    def extract_regex(input)
      input.enum_for(:scan, regex).map do
        match = Regexp.last_match
        Extract.new(
          rule: self,
          value: match[0],
          start: match.begin(0),
          finish: match.end(0)
        )
      end
    end

    def extract_block(input)
      Array(block.call(input)).map do |positions|
        start, finish = positions

        Extract.new(
          rule: self,
          value: input[start...finish],
          start: start,
          finish: finish
        )
      end
    end
  end
end
