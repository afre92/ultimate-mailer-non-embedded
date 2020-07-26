# frozen_string_literal: true

module ApplicationHelper


  def image_tag_remote(image)
    return tag.img class: 'review-photo', src: "#{ENV['APP_URL']}#{url_for(image)}" 
  end
end
