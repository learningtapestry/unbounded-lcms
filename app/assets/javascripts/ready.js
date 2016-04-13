function ready(fn) {
  $(document).on('ready', fn);
  $(document).on('page:load', fn);
}
