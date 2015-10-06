(function() {

  var Lessons = {};

  function visit(url) {
    if (window.Turbolinks) {
      window.Turbolinks.visit(url);
    } else {
      window.location.href = url;
    }
  }

  function getSelectize(jqElm) {
    return jqElm[0].selectize;
  }

  function getGradeName(selectize, value) {
    return selectize.getItem(value)[0].innerHTML.replace(' ', '_');
  }

  function subjectDropdown() {
    return $('select.curriculum-filter-subject');
  }

  function gradeDropdown() {
    return $('select.curriculum-filter-grade');
  }

  function standardDropdown() {
    return $('select.curriculum-filter-standard');
  }

  function highlightLessons(highlights) {
    _.each(highlights, function(alignment) {
      _.each(alignment.highlights, function(highlight) {
        if (highlight in Lessons) {
          $(Lessons[highlight]).addClass('lesson-active');
        }
      });
    });
  }

  function initializeLessonIndex() {
    $('[data-lobject-id]').each(function(elm) {
      Lessons[parseInt($(this).data('lobject-id'))] = this;
    });
  }

  function initializeSubjectDropdown() {
    var selectize = getSelectize(subjectDropdown());
    selectize.on('change', function(newVal) {
      var newLocation;
      if (newVal === 'all') {
        newLocation = Routes.unbounded_curriculum_path();
      } else {
        var locationParams = { subject: newVal };

        var gradeSelectize = getSelectize(gradeDropdown());
        var gradeVal = gradeSelectize.getValue();
        if (gradeVal.length) {
          locationParams.grade = getGradeName(gradeSelectize, gradeVal);
        }

        newLocation = Routes.unbounded_curriculum_path(locationParams);
      }
      visit(newLocation);
    });
  }

  function initializeGradeDropdown() {
    var selectize = getSelectize(gradeDropdown());
    selectize.on('change', function(newVal) {
      var newLocation;
      if (newVal === 'all') {
        newLocation = Routes.unbounded_curriculum_path({
          subject: subjectDropdown().val()
        });
      } else {
        newLocation = Routes.unbounded_curriculum_path({
          subject: subjectDropdown().val(),
          grade: getGradeName(selectize, newVal)
        });
      }
      visit(newLocation);
    });
  }

  function initializeStandardDropdown() {
    var selectize = getSelectize(standardDropdown());
    selectize.on('change', function(newVal) {
      if (_.includes(newVal, 'all')) {
        $('.lesson-active').removeClass('lesson-active');
        selectize.setValue([], true);
        selectize.close();
        selectize.open();
        return;
      }

      Unbounded.highlights.fetchHighlights({
        subject: subjectDropdown().val(),
        grade: gradeDropdown().val(),
        standards: newVal
      }, highlightLessons);
    });

    var currentValue = selectize.getValue();
    if (currentValue.length) {
      fetchHighlights({
        subject: subjectDropdown().val(),
        grade: gradeDropdown().val(),
        standards: currentValue
      }, highlightLessons);
    }
  }

  function initializeCurriculum() {
    initializeLessonIndex();
    initializeSubjectDropdown();
    initializeGradeDropdown();
    initializeStandardDropdown();
    Unbounded.initializePreviews();
  }

  window.initializeCurriculum = function() {
    if ($('.curriculum-page').length) {
      initializeCurriculum();
    }
  };

})(window);
