$(function () {
  function initAddThis() {
    const strNote = ($('.o-social-sharing__teaser').length) ? $('.o-social-sharing__teaser').html().trim() : '';
    window.addthis_config = {
      ui_use_css: false,
      ui_email_note: strNote,
      data_track_addressbar: false,
      pubid: 'ra-57296f7d01842a01'
    };
    window.addthis_share = {
      url_transforms : {
        shorten: {
          twitter: 'bitly'
        }
      },
      shorteners : {
        bitly : {}
      }
    };
  }

  // function addAddThisClasses() {
  //   let $socialSharing = $('.o-social-sharing');
  //   if (!$socialSharing.length) return;
  //   $socialSharing.addClass('addthis_toolbox');
  //   $socialSharing.find('a').each(function() {
  //     const $el = $(this);
  //     const cl = $el.attr('class').replace('o-social-sharing__', 'addthis_button_');
  //     $el.addClass(cl);
  //   });
  // }

  window.initializeSocialSharing = () => {
    // Remove all global properties set by addthis, otherwise it won't reinitialize
    for (var i in window) {
       if (/^addthis/.test(i) || /^_at/.test(i)) {
        delete window[i];
      }
    }
    // Finally, load addthis
    $.getScript('//s7.addthis.com/js/300/addthis_widget.js#async=1', () => {
      initAddThis();
      //addAddThisClasses();
      addthis.init();
    });
  }
})
