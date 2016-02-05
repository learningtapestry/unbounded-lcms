Unbounded.highlights = {
  _highlights: [],
  fetchHighlights: function(options, callback) {
    var that = this;

    $('.lesson-active').find('use').attr('xlink:href', '');
    $('.lesson-active').removeClass('lesson-active');

    $.ajax({
      dataType: 'json',
      url: Routes.curriculum_highlights_path(),
      data: {
        subject: options.subject,
        grade: options.grade,
        standards: options.standards
      },
      success: function(data) {
        that._highlights = data;
        callback(data);
      }
    });
  },
  findHighlights: function(resourceId) {
    return _.filter(this._highlights, function(alignment) {
      return _.some(alignment.highlights, function(highlightedId) {
        return highlightedId == resourceId;
      });
    });
  },
  getHighlights: function() {
    return this._highlights;
  }
};
