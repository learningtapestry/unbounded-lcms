class StandardEmphasis < ActiveRecord::Base
  belongs_to :standard

  validates :emphasis, presence: true
end
