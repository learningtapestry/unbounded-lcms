//= require vendor/pdf.js
//= require vendor/pdf.worker.js

/**
 * Get page info from document, set scale/canvas accordingly, and render page.
 * @param pdfDoc Pdf file.
 * @param num Page number.
 */
function renderPage(pdfDoc, num) {
  var canvas = document.getElementById('o-generic-preview__canvas');
  var context = canvas.getContext('2d');
  // Using promise to fetch the page
  pdfDoc.getPage(num).then(function(page) {
    var viewport = page.getViewport(1);
    var desiredWidth = $('.o-generic-preview').width;
    var scale = desiredWidth / viewport.width;
    var scaledViewport = page.getViewport(scale);
    canvas.height = viewport.height;
    canvas.width = viewport.width;

    // Render PDF page into canvas context
    var renderContext = {
      canvasContext: context,
      viewport: viewport
    };
    page.render(renderContext);
  });
}

ready(function() {
  if (!$('.o-generic-preview').length) return;
  PDFJS.getDocument(pdfUrl).then(function (pdfDoc) {
    // first page rendering
    renderPage(pdfDoc, 1);
  });
});
