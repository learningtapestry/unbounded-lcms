var addthis_config = {
  ui_use_css: false,
  ui_email_note: 'Unbounded',
  data_track_addressbar: false,
  pubid: 'ra-57296f7d01842a01'
};
var addthis_share = {
  url_transforms : {
    shorten: {
      twitter: 'bitly'
    }
  },
  shorteners : {
    bitly : {}
  }
};

window.initializeSocialSharing = () => {
  addthis_config.ui_email_note = ($('.o-social-sharing__teaser').length) ? $('.o-social-sharing__teaser').html().trim() : '';
  addthis.toolbox('.addthis_toolbox');
}
