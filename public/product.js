
// make sure this only loads on products page
// Modal initializer
$('body').on('click','.ue-trigger',function() {
  $('.ue-modal-wrapper').toggleClass('open');
  $('.ue-page-wrapper').toggleClass('ue-blur');
  return false;
});


function getProductInfo(){
  var product = $('#ProductJson-product-template').text();
  return product = JSON.parse(product)
}

if ($('#ProductJson-product-template').length > 0) {
  
  var product = getProductInfo()
  loadReviews(product);
  paginationHandler(product);
};

function loadReviews(product) {
  getReviews({ id: product.id, method: 'reviews' });
}

function paginationHandler(product){
  $('body').on('click', '.ue-pagination > a',function(e){
    e.preventDefault();
    var searchParams = new URLSearchParams($(this).attr('href'))
    getReviews({ id: product.id, page: searchParams.get('page'), method: 'reviews' })
  });
}


function addRatingsBellowPrice(){
  var median = $('#ue-total-review-description').data('reviews-median')
  var reviewsCount = $('#ue-total-review-description').data('reviews-count')
  var template = `<div class="ue-small-rating">
                    <div class="ue-rating-upper" style="width: ${median*10*2}%;">
                        <span>★</span>
                        <span>★</span>
                        <span>★</span>
                        <span>★</span>
                        <span>★</span>
                    </div>
                    <div class="ue-rating-lower">
                        <span>★</span>
                        <span>★</span>
                        <span>★</span>
                        <span>★</span>
                        <span>★</span>
                    </div>
                  </div><span>  ${median} Based on ${reviewsCount} reviews </span>`
  $('#ue-small-ratings-wrapper').html(template)
}


$('body').on('click', '.review-photo',function(e){
  var reviewId = $(this).parent('div.review-images-wrapper').data('review-id');
  $.get( `${window.location.origin}/a/s`, {review_id: reviewId, method: 'review_images'})
  .done(function(data){
    //TODO: change path to not
    $('.ue-review-images-modal').addClass('visible');
    $('.ue-modal-content').html(data)
  
    var slideIndex = 0;
    showSlides(slideIndex);

    return false;
    
    // try to find source code for modal and if not then add bootrap js :/
    // paste modal and show
  })
  .fail(function(){
    console.log("something failed")
  })
})


$('body').on('submit', 'form#review-form',function(e){
  e.preventDefault();
  var shopifyId = $("#shopify-product-reviews").data('id');
  // debugger
  
  $.get( `${window.location.origin}/a/s`, {product_title: $("#shopify-product-reviews").data('title'), review: $('form#review-form').serializeArray(),product_id: shopifyId, method: "create_review_from_form"})
  .done(function(data){


    $('#ue-review-form-container').html(`
    <div class="col-md-12" id="ue-review-submitted-container">
      <div>
        <span >THANK YOU FOR YOUR REVIEW !!!</span>
      </div>
    </div>`)
    
  })
  .fail(function(){
    console.log("something failed")
  })
})

function getReviews(params){
  debugger
  $.get( `${window.location.origin}/a/s`, params)
  .done(function(data){
    debugger
    $('div.product-template__container').after(data)
    // addRatingsBellowPrice();
  })
  .fail(function(){
    console.log("something failed")
  })
}

// Js for slide show


function plusSlides(n) {
  showSlides(slideIndex += n);
}

function currentSlide(n) {
  showSlides(slideIndex = n);
}

function showSlides(n) {
  var i;
  var slides = document.getElementsByClassName("mySlides");
  var dots = document.getElementsByClassName("dot");
  if (n > slides.length) {slideIndex = 1}    
  if (n < 1) {slideIndex = slides.length}
  for (i = 0; i < slides.length; i++) {
      slides[i].style.display = "none";  
  }
  for (i = 0; i < dots.length; i++) {
      dots[i].className = dots[i].className.replace(" active", "");
  }
  slides[slideIndex-1].style.display = "block";  
  dots[slideIndex-1].className += " active";
}


$('body').on('click', '#ue-open-review-form-modal',function(e){
  $('#ue-review-form-container').toggleClass('ue-show');
})