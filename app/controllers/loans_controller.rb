class LoansController < ApplicationController
  def simulate
    result = SimulateLoanUseCase.new(
      value: loan_params[:value],
      birthday: loan_params[:birthday],
      months: loan_params[:months]
    ).call

    render json: result
  end

  private
  
  def loan_params
    params.permit(:value, :birthday, :months)
  end
end
