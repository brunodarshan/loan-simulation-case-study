# app/use_cases/simulate_loan_use_case.rb
class SimulateLoanUseCase
  PRECISION = 4
  def initialize(value:, birthday:, months:)
    @value = value.to_f
    @birthday = birthday
    @months = months.to_i
    @age = calculate_age(birthday)
  end

  def call
    rate = interest_rate
    installment = calculate_installment(@value, rate, @months)
    fees = (installment * @months) - @value

    {
      total_amount: (@value + fees).round(PRECISION),
      installments: installment.round(PRECISION),
      fees: fees.round(PRECISION)
    }
  end

  private

  def calculate_age(birthday)
    today = Date.today
    age = today.year - birthday.year
    age -= 1 if today < birthday + age.years
    age
  end

  def interest_rate
    case @age
    when 18..25 then 0.05
    when 26..40 then 0.03
    when 41..60 then 0.02
    else 0.04
    end
  end

  def calculate_installment(pv, annual_rate, n)
    r = annual_rate / 12.0
    return pv / n if r == 0
    pv * (r * (1 + r)**n) / ((1 + r)**n - 1)
  end
end
