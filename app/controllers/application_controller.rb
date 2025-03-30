class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def simulate
    result = SimulateLoanUseCase.new(**params).call

    render json: result
  end
end
