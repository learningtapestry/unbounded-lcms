module Admin::CurriculumsHelper
  def param_constants
    {
      grades: {
          'pk' => 'prekindergarten',
          'k' => 'kindergarten',
          '1' => 'grade 1',
          '2' => 'grade 2',
          '3' => 'grade 3',
          '4' => 'grade 4',
          '5' => 'grade 5',
          '6' => 'grade 6',
          '7' => 'grade 7',
          '8' => 'grade 8',
          '9' => 'grade 9',
          '10' => 'grade 10',
          '11' => 'grade 11',
          '12' => 'grade 12'
      },
      curriculum_types: {
        'map' => CurriculumType.map,
        'grade' => CurriculumType.grade,
        'module' => CurriculumType.module,
        'unit' => CurriculumType.unit,
      },
      subjects: [
        'ela', 'math'
      ]
    }
  end
end
