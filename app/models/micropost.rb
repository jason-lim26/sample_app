class Micropost < ApplicationRecord
  # The 'belongs_to :user' was automatically generated as a result of the 
  # $ ...user:references command when generating a micropost model.
  belongs_to :user
  # We'll adopt a design of one image per micropost for our application, but
  # Active Storage also offers a second option, 'has_many_attached', which 
  # allows for the attachment of multiple files to a single Active Record object.
  has_one_attached :image
  # Set the default order:
  # Here, DESC is SQL for 'descending', i.e., in descending order from newest to
  # oldest.
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # Validates the type and size of image (this is run by gem 
  # 'active_storage_validations', '0.8.9')
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
                                      
  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
