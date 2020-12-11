def calculate_payment(loan_amount, monthly_interest_rate, monthly_loan_duration)
  loan_amount * (monthly_interest_rate /
    (1 - ((1 + monthly_interest_rate)**(monthly_loan_duration * -1))))
end

# GET loan amount
loan_amount = nil
loop do
  puts ">> Loan Amount:"
  loan_amount = gets.chomp.to_f
  break if loan_amount > 0
  puts ">> Enter a valid loan amount!"
end
# GET Annual Percentage Rate
apr = nil
loop do
  puts ">> Annual Percentage Rate:"
  apr = gets.chomp.to_f
  break if apr > 0
  puts ">> Enter a valid APR!"
end
# GET loan duration
loan_duration = nil
loop do
  puts ">> Loan duration (in years):"
  loan_duration = gets.chomp.to_i
  break if loan_duration > 0
  puts ">> Enter a valid loan duration"
end

# Calculate monthly interest rate
monthly_interest_rate = (apr / 12) * 0.01
# Calculate loan duration in months
monthly_loan_duration = loan_duration * 12
# Calculate monthly payment
monthly_payment =
  calculate_payment(loan_amount, monthly_interest_rate, monthly_loan_duration)
puts "Your monthly payment is: $#{monthly_payment.round(2)}"
