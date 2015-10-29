require 'spec_helper'

RSpec::Matchers.define :be_redacted do |reason, redactor|
  match do |actual|
    redactor.extract(actual).any? do |extract|
      extract.value == actual && extract.reason == reason
    end
  end
end

describe 'Redactor rules' do
  let(:redactor) do
    Redactor.new do
      # US phone
      rule :phone, /(\+?1[ \.-]?)?\(?\d{3}\)?[ \.-]?\d{3}[ \.-]?\d{4}/

      # email
      rule :email, /[\w\.]+ ?(@|at) ?\w+\ ?(\.|dot) ?\w{1,3}/i
    end
  end

  {
    '1 234 567 8901' => :phone,
    '12345678901' => :phone,
    '1-234-567-8901' => :phone,
    '1.234.567.8901' => :phone,
    '+1-234-567-8901' => :phone,
    '1-(234) 5678901' => :phone,
    'foo@bar.baz' => :email,
    'foo.bar@baz.qux' => :email,
    'FOO@bar.baz' => :email,
    'foo @ bar . baz' => :email,
    'foo at bar dot baz' => :email,
    'foo AT bar DOT baz' => :email
  }.each do |value, reason|
    describe(value) do
      it { should be_redacted(reason, redactor) }
    end
  end
end
