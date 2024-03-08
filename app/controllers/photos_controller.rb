class PhotosController < ApplicationController
  def show
    photo = Photo.find(params[:id])
    response = {
      id: photo.id,
      imageUrl: "http://#{request.env["HTTP_HOST"]}/#{photo.image_name}"
    }
    render json: response
  end
end
