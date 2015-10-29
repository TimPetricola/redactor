require 'spec_helper'

describe Redactor do
  let(:foobar_rule) { Redactor::Rule.new(:foobar, /foobar/) }
  let(:barbaz_rule) { Redactor::Rule.new(:barbaz, /barbaz/) }

  it 'accepts a single rule' do
    redactor = Redactor.new(foobar_rule)
    expect(redactor.rules).to eq [foobar_rule]
  end

  it 'accepts an array of rule' do
    redactor = Redactor.new([foobar_rule])
    expect(redactor.rules).to eq [foobar_rule]
  end

  it 'accepts a block' do
    redactor = Redactor.new do
      rule :foo, /foo/
    end
    expect(redactor.rules.length).to be 1
    expect(redactor.rules[0].reason).to eq :foo
  end

  describe '.extract' do
    let(:redactor) do
      redactor = Redactor.new
      redactor.register_rule(foobar_rule)
      redactor.register_rule(barbaz_rule)
      redactor
    end

    it 'return extracts' do
      text = 'hello barbaz foobar'
      results = redactor.extract(text)
      expect(results.first.rule).to be foobar_rule
      expect(results.first.value).to eq 'foobar'
      expect(results.last.rule).to be barbaz_rule
      expect(results.last.value).to eq 'barbaz'
    end

    context 'colliding rules' do
      it "only keep first defined rule's match" do
        text = 'hello foobarbaz'
        results = redactor.extract(text)
        expect(results.size).to eq 1
        expect(results.first.rule).to be foobar_rule
      end
    end
  end

  describe '.format' do
    let(:redactor) do
      redactor = Redactor.new
      redactor.register_rule(foobar_rule)
      redactor.register_rule(barbaz_rule)
      redactor
    end

    it 'replaces redacted parts' do
      text = 'hello barbaz foobar'
      expect(redactor.format(text)).to eq 'hello [REDACTED] [REDACTED]'
    end

    it 'accepts a block for redacted strings' do
      text = 'hello barbaz foobar'

      redacted = redactor.format(text) do |extract|
        "[#{extract.reason.upcase}]"
      end

      expect(redacted).to eq 'hello [BARBAZ] [FOOBAR]'
    end

    it 'does not mutate original string' do
      text = 'hello barbaz foobar'
      redactor.format(text)
      expect(text).to eq 'hello barbaz foobar'
    end
  end
end
