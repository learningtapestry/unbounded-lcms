class LeadershipPost < ActiveRecord::Base
  validates :first_name, :last_name, presence: true
  validates :dsc, length: { maximum: 4096 }

  scope :order_by_name_with_precedence, -> { order(:order, :last_name) }

  def name
    "#{first_name} #{last_name}"
  end
end
