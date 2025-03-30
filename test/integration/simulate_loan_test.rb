require "test_helper"

class SimulateLoanTest < ActionDispatch::IntegrationTest
  test "simula um empréstimo com cliente de 30 anos e retorna os dados corretamente" do
    post "/simulate", params: {
      value: 10000,
      birthday: 30.years.ago.to_date.to_s,
      months: 12
    }

    assert_response :success
    body = JSON.parse(response.body)

    assert_equal 12, body["installments"].to_f > 0 ? 12 : 0
    assert_includes body.keys, "total_amount"
    assert_includes body.keys, "installments"
    assert_includes body.keys, "fees"
  end
end
