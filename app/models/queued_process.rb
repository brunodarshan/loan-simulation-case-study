class QueuedProcess < ApplicationRecord
  enum :status, [:queued, :processed, :failure]

  def self.generate_unique_process_id
    process_id = nil

    loop do
      process_id = SecureRandom.uuid

      break unless exists?(process_id: process_id)
    end

    process_id
  end
end
