puts "Give me a string:"
str = gets
y = str         .tap { |x| p x }
    .split("")  .tap { |x| p x }
    .sort       .tap { |x| p x }
  
p y