class Grade < ActiveRecord::Base
  validates :name, presence: true

  default_scope { order(:grade) }

  alias_attribute :name, :grade

  def self.from_names(names)
    names = Array.wrap(names)

    fixed_names = names.map do |name|
      name = name.to_s
      if name.upcase == 'K'
        name = 'kindergarten'
      elsif name.upcase == 'PK'
        name = 'prekindergarten'
      elsif !name.start_with?('grade')
        name = "grade #{name}"
      end
      name
    end

    where(name: fixed_names)
  end

end
