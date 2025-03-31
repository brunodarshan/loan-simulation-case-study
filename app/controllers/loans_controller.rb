class LoansController < ApplicationController
  def simulate
    result = SimulateLoanUseCase.new(
      value: loan_params[:value],
      birthday: loan_params[:birthday],
      months: loan_params[:months]
    ).call

    render json: result
  end

  def simulate_on_queue
    file = params[:file]
    return render json: { error: "Arquivo não enviado" }, status: :bad_request unless file

    process = UploadToSimulateUseCase.call(file)

    render json: { process: process }
  end

  private
  
  def loan_params
    params.permit(:value, :birthday, :months)
  end
end
