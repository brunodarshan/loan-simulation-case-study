require "test_helper"
require "minitest/mock"

class UploadCSVToSimulateUseCaseTest < ActiveSupport::TestCase
  DummyFile = Struct.new(:original_filename, :read)

  def setup
    @dummy_file = DummyFile.new("test.csv", "1000,1995-03-09,12")
    @process_id = SecureRandom.uuid
    @s3_key = "uploads/123abc.csv"
  end

  test "call uploads file, creates queued process and returns process_id" do
    S3Uploader.stub(:upload, @s3_key) do
      queued_process_instance = Minitest::Mock.new
      queued_process_instance.expect(:process_id, @process_id)

      QueuedProcess.stub(:create!, queued_process_instance) do
        QueuedProcess.stub(:generate_unique_process_id, @process_id) do

          result = ::UploadToSimulateUseCase.call(@dummy_file)

          assert_equal @process_id, result
          queued_process_instance.verify
        end
      end
    end
  end
end
