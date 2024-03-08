class PhotosController < ApplicationController
  def show
    photo = Photo.find(params[:id])
    response = {
      id: photo.id,
      image_url: "http://#{request.env["HTTP_HOST"]}/#{photo.image_name}"
    }
    render json: response
  end
end
