$(function () {
  window.initializePDFPreview = () => {
    if (!$('.o-resource__pdf-preview--full').length) return;

    if (PDFObject.supportsPDFs) {
      const options = {
        pdfOpenParams: { page: 1, view: 'Fit' }
      };
      PDFObject.embed(pdfUrl, '.o-resource__pdf-preview--full', options);
    } else {
      $('.o-resource__pdf-preview--full').append(`<iframe src="${pdfUrl}"></iframe>`);
    }
  };
});
