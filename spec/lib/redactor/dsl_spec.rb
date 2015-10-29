require 'spec_helper'

describe Redactor::DSL do
  describe 'new rule' do
    context 'with regex' do
      it 'is registered' do
        definitions = proc do
          rule :foo, /foo/
        end

        redactor = double
        rule = double('Redactor::Rule')

        expect(Redactor::Rule).to(
          receive(:new).with(:foo, /foo/).and_return(rule)
        )

        expect(redactor).to receive(:register_rule).with(rule)

        Redactor::DSL.run(redactor, definitions)
      end
    end

    context 'with block' do
      it 'is registered' do
        proc = proc

        definitions = proc do
          rule(:foo, &proc)
        end

        redactor = double
        rule = double('Redactor::Rule')

        expect(Redactor::Rule).to(
          receive(:new).with(:foo, nil) do |*_args, &block|
            expect(proc).to be(block)
            rule
          end
        )

        expect(redactor).to receive(:register_rule).with(rule)

        Redactor::DSL.run(redactor, definitions)
      end
    end
  end
end
