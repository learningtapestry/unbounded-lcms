# frozen_string_literal: true

module TagsHelper
  TAG_GROUPS = {
    ccss_standards: 'CCSS Standard',
    ccss_domain:    'CCSS Domain',
    ccss_cluster:   'CCSS Cluster',
    texts:          'Texts',
    authors:        'Authors',
  }.freeze

  def render_tag_clouds(named_tags, color_code)
    render partial: 'resources/tags',
           locals: { tag_clouds: tag_clouds(named_tags), color_code: color_code }
  end

  def tag_clouds(named_tags)
    named_tags[:ell_appropriate] = named_tags[:ell_appropriate] ? 'ELL Appropriate' : nil
    named_tags.transform_values { |v| Array.wrap(v).flatten.compact.uniq.sort }
  end

  def each_tags_cloud!(tag_clouds)
    no_tags = tag_clouds.values.none?(&:present?)
    TAG_GROUPS.each do |group_id, group_name|
      tags = tag_clouds.delete(group_id)
      yield(tags, group_name) if tags.present?
    end
    tags = tag_clouds.values.flatten.compact.uniq
    yield(tags, nil) if tags.present? || no_tags
  end
end
