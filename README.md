# redactor [![Gem Version](https://badge.fury.io/rb/redactor.svg)](https://rubygems.org/gems/redactor) [![Build Status](https://travis-ci.org/TimPetricola/redactor.svg)](https://travis-ci.org/TimPetricola/redactor)

Redact parts of text defined by custom rules (e.g. emails, phone numbers).

## Usage

```rb
require 'redactor'

input = 'To ride a kayak, contact me: tim.petricola@gmail.com or 1 234 567 8901.'

# these rules are only good enough for an example
redactor = Redactor.new do
  # US phone
  rule :phone, /(\+?1[ \.-]?)?\(?\d{3}\)?[ \.-]?\d{3}[ \.-]?\d{4}/

  # email
  rule :email, /[\w\.]+(@|at)\w+(\.|dot)\w{1,3}/i

  # palindrome
  rule :palindrome do |input|
    words = input.split(/\W+/)
    palindromes = words.select { |w| w.length > 2 && w == w.reverse }
    palindromes.map do |w|
      start = input.index(w)
      finish = start + w.length - 1
      [start, finish]
    end
  end
end

redactor.format(input)
# => "To ride a [REDACTED], contact me: [REDACTED] or [REDACTED]."

redactor.default_replacement = '$#@!&'
# => "To ride a $\#@!&, contact me: $\#@!& or $\#@!&."

redactor.format(input) do |extract|
  "[#{extract.reason.upcase}]"
end
# => "To ride a [PALINDROME], contact me: [EMAIL] or [PHONE]."

redactor.extract(input)
# => [#<Redactor::Extract:0x007ff259586008
#   @finish=70,
#   @rule=#<Redactor::Rule:0x007ff258b5aa20 @block=nil, @reason=:phone, @regex=/(\+?1[ \.-]?)?\(?\d{3}\)?[ \.-]?\d{3}[ \.-]?\d{4}/>,
#   @start=56,
#   @value="1 234 567 8901">,
#  #<Redactor::Extract:0x007ff259585cc0
#   @finish=52,
#   @rule=#<Redactor::Rule:0x007ff258b5a9f8 @block=nil, @reason=:email, @regex=/[\w\.]+(@|at)\w+(\.|dot)\w{1,3}/i>,
#   @start=29,
#   @value="tim.petricola@gmail.com">,
#  #<Redactor::Extract:0x007ff259585518
#   @finish=15,
#   @rule=#<Redactor::Rule:0x007ff258b5a980 @block=#<Proc:0x007ff258b5a9a8@/Users/Tim/Projects/redactor/test.rb:14>, @reason=:palindrome, @regex=nil>,
#   @start=10,
#   @value="kayak">]

```
