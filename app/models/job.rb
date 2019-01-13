class Job < ApplicationRecord
  belongs_to :user
  JOB_TYPES = ["Full-time", "Part-time", "Contract", "Freelance"]
end
