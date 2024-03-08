class PhotoObjectsController < ApplicationController
  def index
    photo_objects = PhotoObject.where(photo_id: params[:photo_id])
    response = photo_objects.map do |photo_object|
      {
        id: photo_object.id,
        name: photo_object.name,
        image_url: "http://#{request.env["HTTP_HOST"]}/#{photo_object.image_name}"
      }
    end

    render json: response
  end
end
