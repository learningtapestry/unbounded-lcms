const curriculumMapComponents = {
    'grade': ExploreCurriculumGradeMap,
    'module': ExploreCurriculumModuleMap,
    'unit': ExploreCurriculumUnitMap,
    'lesson': ExploreCurriculumGradeMap
};

function cssCurrirulumMapClasses(baseClass) {
  const cssClasses = ['module-wrap', 'module', 'units-wrap', 'units', 'unit', 'lesson'];
  let arrClasses = cssClasses.map(
     (v) => { return `${baseClass}__${v}`;}
   );
   return _.zipObject(cssClasses, arrClasses);
}
