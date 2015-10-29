require 'spec_helper'

describe Redactor do
  before do
    @foobar_rule = Redactor::Rule.new(:foobar, /foobar/)
    @barbaz_rule = Redactor::Rule.new(:barbaz, /barbaz/)
    Redactor.register_rule(@foobar_rule)
    Redactor.register_rule(@barbaz_rule)
  end

  after { Redactor.clear }

  describe '.extract' do
    it 'return extracts' do
      text = 'hello barbaz foobar'
      results = Redactor.extract(text)
      expect(results.first.rule).to be @foobar_rule
      expect(results.first.value).to eq 'foobar'
      expect(results.last.rule).to be @barbaz_rule
      expect(results.last.value).to eq 'barbaz'
    end

    context 'colliding rules' do
      it "only keep first defined rule's match" do
        text = 'hello foobarbaz'
        results = Redactor.extract(text)
        expect(results.size).to eq 1
        expect(results.first.rule).to be @foobar_rule
      end
    end
  end

  describe '.format' do
    it 'replaces redacted parts' do
      text = 'hello barbaz foobar'
      expect(Redactor.format(text)).to eq 'hello [REDACTED] [REDACTED]'
    end

    it 'accepts a block for redacted strings' do
      text = 'hello barbaz foobar'

      redacted = Redactor.format(text) do |extract|
        "[#{extract.reason.upcase}]"
      end

      expect(redacted).to eq 'hello [BARBAZ] [FOOBAR]'
    end

    it 'does not mutate original string' do
      text = 'hello barbaz foobar'
      Redactor.format(text)
      expect(text).to eq 'hello barbaz foobar'
    end
  end
end
