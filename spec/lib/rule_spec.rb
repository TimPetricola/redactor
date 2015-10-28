require 'spec_helper'

describe Redactor::Rule do
  it 'can be built with a regex' do
    rule = Redactor::Rule.new(:foo, /foo/)
    expect(rule.reason).to eq :foo
    expect(rule.regex).to eq(/foo/)
  end

  it 'can be built with a block' do
    rule = Redactor::Rule.new(:foo) { |input| input }
    expect(rule.reason).to eq :foo
    expect(rule.block).not_to be_nil
  end

  it 'needs a regex or a block' do
    expect {
      Redactor::Rule.new(:foo)
    }.to raise_error(ArgumentError)
  end

  it 'can not have a regex and a block' do
    expect {
      Redactor::Rule.new(:foo, /foo/) { |input| input }
    }.to raise_error(ArgumentError)
  end

  describe '#extract' do
    context 'with regex' do
      let(:text) do
        'Lorem foo bar ipsum dolor sit amet, foobar adipiscing elit.'
      end
      let(:rule) { Redactor::Rule.new(:foo_bar, /foo ?bar/) }
      let(:results) { rule.extract(text) }

      it 'returns values and positions of first match' do
        extract = results.first
        expect(extract.rule).to be rule
        expect(extract.value).to eq 'foo bar'
        expect(extract.start).to eq 6
        expect(extract.finish).to eq 13
      end

      it 'returns values and positions of others matches' do
        extract = results[1]
        expect(extract.rule).to be rule
        expect(extract.value).to eq 'foobar'
        expect(extract.start).to eq 36
        expect(extract.finish).to eq 42
      end
    end

    context 'with block' do
      let(:text) do
        'I want a kayak, a poney or a racecar.'
      end

      let(:rule) do
        Redactor::Rule.new(:palindrome) do |input|
          input.split(/\W+/)
            .select { |w| w.length > 2 && w == w.reverse }
            .map do |word|
              start = input.index(word)
              finish = start + word.length
              [start, finish]
            end
        end
      end

      let(:results) { rule.extract(text) }

      it 'returns values and positions of first match' do
        extract = results.first
        expect(extract.rule).to be rule
        expect(extract.value).to eq 'kayak'
        expect(extract.start).to eq 9
        expect(extract.finish).to eq 14
      end

      it 'returns values and positions of others matches' do
        extract = results[1]
        expect(extract.rule).to be rule
        expect(extract.value).to eq 'racecar'
        expect(extract.start).to eq 29
        expect(extract.finish).to eq 36
      end
    end
  end
end
