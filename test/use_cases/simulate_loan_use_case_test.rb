require "test_helper"

class SimulateLoanUseCaseTest < ActiveSupport::TestCase
  def setup
    @value = 10_000.0
    @months = 12
  end

  test "cliente com até 25 anos recebe 5% de juros ao ano" do
    simulate_and_assert(years_ago: 20, expected_rate: 0.05)
  end

  test "cliente com 30 anos recebe 3% de juros ao ano" do
    simulate_and_assert(years_ago: 30, expected_rate: 0.03)
  end

  test "cliente com 50 anos recebe 2% de juros ao ano" do
    simulate_and_assert(years_ago: 50, expected_rate: 0.02)
  end

  test "cliente com 70 anos recebe 4% de juros ao ano" do
    simulate_and_assert(years_ago: 70, expected_rate: 0.04)
  end

  private

  def simulate_and_assert(years_ago:, expected_rate:)
    birthday = years_ago.years.ago.to_date.to_s
    result = SimulateLoanUseCase.new(value: @value, birthday: birthday, months: @months).call

    total_expected = (@value * (1.0 + expected_rate)).round(4)
    expected_installments = (total_expected / @months).round(4)
    expected_fees = (@value * expected_rate).round(4)

    assert expected_installments, result[:installments]
    assert total_expected, result[:total_amount]
    assert expected_fees, result[:fees]
  end
end
