require "test_helper"
require "tempfile"


class UploadFileToSimulateLaterTest < ActionDispatch::IntegrationTest
  test "faz upload de CSV, envia ao S3 e cria QueuedProcess" do
    Tempfile.create(["simulations", ".csv"]) do |file|
      file.write("10000,1990-01-01,12\n")
      file.rewind

      assert_difference("QueuedProcess.count", 1) do
        post "/upload_csv", params: { file: file }
  
        assert_response :accepted
  
        body = JSON.parse(response.body)
        assert body["process_id"].present?
  
        process = QueuedProcess.find_by(process_id: body["process_id"])
        assert_equal "queued", process.status
        assert process.file.include?("uploads/")
      end
    end
  end
end
