/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

console.log('hello ')

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("jquery")

const Uppy = require('@uppy/core')
const Dashbord = require('@uppy/dashboard')
const ActiveStorageUpload = require("@excid3/uppy-activestorage-upload")

require('@uppy/core/dist/style.css')
require('@uppy/dashboard/dist/style.css')


document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('[data-uppy]').forEach(element => setupUppy(element))
})

function setupUppy(element) {
  
  let form = element.closest('form')
  let direct_upload_url = document.querySelector("meta[name='direct-upload-url']").getAttribute('content')
  let field_name = element.dataset.uppy

  let uppy = Uppy({
    autoProceed: false,
    allowMultipleUploads: false,
    restrictions: {
      maxFileSize: 1000000,
      maxNumberOfFiles: 2,
      allowedFileTypes: ['image/*']
    },
    logger: Uppy.debugLogger
  })

  uppy.use(ActiveStorageUpload, {
    directUploadUrl: direct_upload_url
  })

  uppy.use(Dashbord, {
    target: '.dashboard',
    inline: true,
    closeAfterFinish: false
  })

  uppy.on('complete', (result) => {
    result.successful.forEach( file => {
      appendUploadedFile(element, file, field_name)
      form.submit()
    })
  })
}

function appendUploadedFile(element, file, field_name){
  var hiddenField = document.createElement('input')
  hiddenField.setAttribute('type', 'hidden')
  hiddenField.setAttribute('name', field_name)
  hiddenField.setAttribute('data-pending-upload', true)
  hiddenField.setAttribute('value', file.response.signed_id)
  
  element.appendChild(hiddenField)
}