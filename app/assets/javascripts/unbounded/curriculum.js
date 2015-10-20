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

  function getGradeName(value) {
    return value.replace(' ', '_');
  }

  function getSubjectSelection() {
    return $('.curriculum-subject-selection');
  }

  function getSubjectRadios() {
    return getSubjectSelection().find(':radio');
  }

  function getGradeSelection() {
    return $('.curriculum-grade-selection');
  }

  function getGradeRadios() {
    return getGradeSelection().find(':radio');
  }

  function getStandardDropdown() {
    return $('select.curriculum-filter-standard');
  }

  function highlightLessons(highlights) {
    _.each(highlights, function(alignment) {
      _.each(alignment.highlights, function(highlight) {
        if (highlight in Lessons) {
          $(Lessons[highlight]).addClass('lesson-active');
          $(Lessons[highlight]).find('use').attr('xlink:href', svg_lesson_cc);
        }
      });
    });
  }

  function initializeLessonIndex() {
    $('[data-lobject-id]').each(function(elm) {
      Lessons[parseInt($(this).data('lobject-id'))] = this;
    });
  }

  function getSelectedSubject() {
    return getSubjectRadios().filter(':checked').val() || 'all';
  }

  function getSelectedGrade() {
    var grade = getGradeRadios().filter(':checked').data('grade');
    if (grade) {
      return getGradeName(grade);
    }
    return null;
  }

  function onChangeFilter(e) {
    visit(Routes.unbounded_curriculum_path({
      grade: getSelectedGrade(),
      subject: getSelectedSubject()
    }));
  }

  function initializeSubjectSelection() {
    getSubjectRadios().on('change', onChangeFilter);
  }

  function initializeGradeSelection() {
    getGradeRadios().on('change', onChangeFilter);
  }

  function initializeStandardDropdown() {
    var selectize = getSelectize(getStandardDropdown());
    selectize.on('change', function(newVal) {
      if (_.includes(newVal, 'all')) {
        $('.lesson-active').find('use').attr('xlink:href', '');
        $('.lesson-active').removeClass('lesson-active');
        selectize.setValue([], true);
        selectize.close();
        selectize.open();
        return;
      }

      Unbounded.highlights.fetchHighlights({
        subject: getSubjectRadios().val(),
        grade: getGradeRadios().val(),
        standards: newVal
      }, highlightLessons);
    });

    var currentValue = selectize.getValue();
    if (currentValue.length) {
      fetchHighlights({
        subject: getSubjectRadios().val(),
        grade: getGradeRadios().val(),
        standards: currentValue
      }, highlightLessons);
    }
  }

  function initializeCurriculum() {
    initializeLessonIndex();
    initializeSubjectSelection();
    initializeGradeSelection();
    initializeStandardDropdown();
    Unbounded.initializePreviews();
  }

  window.initializeCurriculum = function() {
    if ($('.curriculum-page').length) {
      initializeCurriculum();
    }
  };

})(window);
