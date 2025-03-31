class UploadToSimulateUseCase
  def self.call(file)
    process_id = QueuedProcess.generate_unique_process_id

    key = S3Uploader.upload(file, "uploads/#{process_id}.csv")

    on_queue = QueuedProcess.create!(
      process_id: process_id,
      status: :queued,
      file: key
    )

    return on_queue.process_id
  end
end
