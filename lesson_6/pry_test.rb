require 'pry'
require 'pry-byebug'

x = %w[a b c d e]
x.map do |num|
  binding.pry
  num + "z"
end

p x