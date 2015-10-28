# redactor

Redact parts of text defined by custom rules (e.g. emails, phone numbers).

## Usage

```rb
require 'redactor'

input = 'To ride a kayak, contact me: tim.petricola@gmail.com or 1 234 567 8901.'

# these rules are only good enough for an example
Redactor.define do
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
      finish = start + w.length
      [start, finish]
    end
  end
end

Redactor.format(input)
# => "To ride a [REDACTED], contact me: [REDACTED] or [REDACTED]."

Redactor.format(input) do |extract|
  "[#{extract.reason.upcase}]"
end
# => "To ride a [PALINDROME], contact me: [EMAIL] or [PHONE]."

Redactor.extract(input)
# => [#<Redactor::Extract:0x007fc05c6b25a0
#   @finish=70,
#   @rule=#<Redactor::Rule:0x007fc05f203970 @block=nil, @reason=:phone, @regex=/(\+?1[ \.-]?)?\(?\d{3}\)?[ \.-]?\d{3}[ \.-]?\d{4}/>,
#   @start=56,
#   @value="1 234 567 8901">,
#  #<Redactor::Extract:0x007fc05c6b2230 @finish=52, @rule=#<Redactor::Rule:0x007fc05f203948 @block=nil, @reason=:email, @regex=/[\w\.]+(@|at)\w+(\.|dot)\w{1,3}/i>, @start=29, @value="tim.petricola@gmail.com">,
#  #<Redactor::Extract:0x007fc05c6b19c0
#   @finish=15,
#   @rule=#<Redactor::Rule:0x007fc05f2038d0 @block=#<Proc:0x007fc05f2038f8@/Users/Tim/Projects/redact/test.rb:13>, @reason=:palindrome, @regex=nil>,
#   @start=10,
#   @value="kayak">]
```
