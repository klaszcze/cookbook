class Author < ApplicationRecord
  belongs_to :user
  has_many :recipes, dependent: :destroy
end
