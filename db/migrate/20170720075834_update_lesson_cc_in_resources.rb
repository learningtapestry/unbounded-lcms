class UpdateLessonCcInResources < ActiveRecord::Migration
  def data
    Curriculum
      .trees.units
      .ela
      .where_grade(['prekindergarten', 'kindergarten', 'grade 1', 'grade 2'])
      .find_each do |unit|
        unit.children.lessons.find_each do |lesson|
          lesson.resource.update(
            engageny_title: unit.resource.engageny_title,
            engageny_url: unit.resource.engageny_url
          )
        end
      end

    cc = 'Developing Core Proficiencies Program: Units in ELA Literacy'
    license = 'This work is licensed under a Creative Commons ' \
      'Attribution-NonCommercial-ShareAlike 4.0 International License.'
    url = 'https://www.engageny.org/resource/developing-core-proficiencies-program-units-in-ela-literacy'

    scope = ResourceSlug
            .select(:curriculum_id)
            .where('value LIKE ?', '%/core-proficiencies')

    tag = Tag.find_or_create_by(name: 'Odell Education')

    Curriculum
      .trees
      .ela
      .where_grade((6..12).map { |g| "grade #{g}" })
      .where(id: scope)
      .each do |curriculum|
        curriculum.resource.copyright_attributions.destroy_all
        curriculum.resource.copyright_attributions.create(value: license)
        curriculum.self_and_descendants.map(&:resource).each do |resource|
          resource.update(engageny_title: cc, engageny_url: url)
          resource.tags << tag unless resource.tags.exists?(name: tag.name)
        end
      end
  end
end
