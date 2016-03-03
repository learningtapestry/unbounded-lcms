class ResourceSlug < ActiveRecord::Base
  belongs_to :resource
  belongs_to :curriculum

  def self.create_for_curriculum(curriculum)
    if slug = find_by(curriculum: curriculum, canonical: true)
      slug.reset_value
      slug.save!
    else
      slug = new(
        resource: curriculum.resource,
        curriculum: curriculum,
        canonical: true
      )
      slug.reset_value
      slug.save!
    end
    slug
  end

  def self.clean_up(str)
    str.strip.gsub(/\s+/, '-').downcase
  end

  def reset_value
    if curriculum.present?
      prefix = if curriculum.resource.ela?
        'ela'
      elsif curriculum.resource.math?
        'math'
      end
      
      short_titles = self.class.clean_up(
        curriculum
        .self_and_ancestors
        .map { |c| c.resource.short_title }
        .reverse
        .join('/')
      )

      self.value = "#{prefix}/#{short_titles}"
    end
  end
end
