require 'spec_helper'

describe 'clear' do
  after { Redactor.clear }

  it 'unload all rules' do
    Redactor.clear
    Redactor.register_rule(double)
    expect { Redactor.clear }.to change { Redactor.rules.size }.from(1).to(0)
  end
end
