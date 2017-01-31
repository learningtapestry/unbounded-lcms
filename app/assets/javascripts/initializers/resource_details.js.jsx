window.initializeResourceDetails = () => {
  $('.o-resource-downloads__btn').click(function(){
    $('.o-resource-downloads__list', $(this).parent()).toggle('fast');
    $('.o-resource-downloads__btn--more', $(this).parent()).toggle();
    $('.o-resource-downloads__btn--less', $(this).parent()).toggle();
  });
}
