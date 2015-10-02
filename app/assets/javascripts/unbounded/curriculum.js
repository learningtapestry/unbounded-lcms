(function() {

  var PreviewTemplate;
  var Lessons = {};
  var Highlights = [];

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

  function subjectDropdown() {
    return $('select.curriculum-filter-subject');
  }

  function gradeDropdown() {
    return $('select.curriculum-filter-grade');
  }

  function standardDropdown() {
    return $('select.curriculum-filter-standard');
  }

  function fetchHighlights(val) {
    $('.lesson-active').removeClass('lesson-active');

    $.ajax({
      dataType: 'json',
      url: Routes.unbounded_curriculum_highlights_path(),
      data: {
        subject: subjectDropdown().val(),
        grade: gradeDropdown().val(),
        standards: val
      },
      success: function(data) {
        Highlights = data;
        highlightLessons();
      }
    });
  }

  function findHighlights(lobjectId) {
    return _.filter(Highlights, function(alignment) {
      return _.some(alignment.highlights, function(highlightedId) {
        return highlightedId == lobjectId;
      });
    });
  }

  function highlightLessons() {
    _.each(Highlights, function(alignment) {
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
        newLocation = Routes.unbounded_curriculum_path({ subject: newVal });
      }
      visit(newLocation);
    });
  }

  function initializeGradeDropdown() {
    var selectize = getSelectize(gradeDropdown());
    selectize.on('change', function(newVal) {
      var gradeName = selectize.getItem(newVal)[0].innerHTML;
      gradeName = gradeName.replace(' ', '_');
      var newLocation;
      if (newVal === 'all') {
        newLocation = Routes.unbounded_curriculum_path({
          subject: subjectDropdown().val()
        });
      } else {
        newLocation = Routes.unbounded_curriculum_path({
          subject: subjectDropdown().val(),
          grade: gradeName
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

      fetchHighlights(newVal);
    });

    var currentValue = selectize.getValue();
    if (currentValue.length) {
      fetchHighlights(currentValue);
    }
  }

  function initializePopover($elm) {
    $('.popover').popover('hide');
    var popover = $elm.data('bs.popover');
    if (!popover) {
      $elm.popover({
        html: true,
        content: I18n.t('ui.loading'),
        template: $('#popover-template').html()
      }).popover('show');
    }
  }

  function openPopover($elm, data) {
    data.highlights = findHighlights($elm.data('lobject-id'))
    data.alignmentsTitle = I18n.t('unbounded.title.alignments')
    var popover = $elm.data('bs.popover');
    popover.options.content = PreviewTemplate(data);
    popover.options.title = data.title;
    popover.show();
  }

  function initializeLessons() {
    $('[data-lobject-id]')
      .mouseenter(function() {
        var $this = $(this);
        initializePopover($this);
        $.ajax({
          dataType: 'json',
          url: Routes.unbounded_resource_preview_path({ id: $this.data('lobject-id') }),
          success: function(data) {
            if ($this.is(':hover')) {
              openPopover($this, data);
            }
          }
        });
      })
      .mouseleave(function(e) {
        e.stopPropagation();
        var $this = $(this);
        setTimeout(function () {
          if (!$('.popover:hover').length) { 
            $this.popover('hide');
          }
        }, 50);
      });
  }
 
  function initializeCurriculum() {
    PreviewTemplate = _.template($('#resource-preview-template')[0].innerHTML);

    $(document).on('mouseleave', '.popover', function () {
      $('.popover').popover('hide');
    });

    initializeLessonIndex();
    initializeSubjectDropdown();
    initializeGradeDropdown();
    initializeStandardDropdown();
    initializeLessons();
  }

  window.initializeCurriculum = function() {
    if ($('.curriculum-page').length) {
      initializeCurriculum();
    }
  };

})(window);
