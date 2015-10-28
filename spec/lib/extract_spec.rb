require 'spec_helper'

describe Redactor::Extract do
  def extract_at(start, finish)
    Redactor::Extract.new(rule: double, value: '', start: start, finish: finish)
  end

  describe '#collides?' do
    let(:extract) { extract_at(10, 20) }

    context 'no collision' do
      it 'is false' do
        expect(extract.collides?(extract_at(0, 9))).to be false
      end
    end

    context 'lower collision' do
      it 'is true' do
        expect(extract.collides?(extract_at(0, 10))).to be true
      end
    end

    context 'upper collision' do
      it 'is true' do
        expect(extract.collides?(extract_at(20, 25))).to be true
      end
    end
  end
end
