$(function () {
  function initSwipers() {
    let swiperVideos = new Swiper('.c-ls-slides--a', {
        slidesPerView: 'auto',
        nextButton: '.c-ls-slides--a__next',
        prevButton: '.c-ls-slides--a__prev',
        spaceBetween: 20
    });
    let swiperPosts = new Swiper('.c-ls-slides--l', {
        slidesPerView: 'auto',
        nextButton: '.c-ls-slides--l__next',
        prevButton: '.c-ls-slides--l__prev'
    });
  }

  window.initializeLeadership = function() {
    if (!$('.c-ls-hero').length) return;
    initSwipers();
    // $('.c-ls-slides__overlay').on('click', (e) => {
    //   console.log('click');
    //   $(".c-ls-slides--a__slide.swiper-slide-active iframe")[0].src += "?autoplay=1";
    //   e.preventDefault();
    // });
  }

})
