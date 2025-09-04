class Submission < ApplicationRecord
    has_one_attached :video_upload   # user’s uploaded video
     has_one_attached :thumbnail      # generated thumbnail
end
