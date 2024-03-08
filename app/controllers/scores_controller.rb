class ScoresController < ApplicationController
  def index
    scores = Score.where(photo_id: params[:photo_id])
    render json: scores
  end

  # TODO - to test
  def create
    score = Score.new(create_params)
    if score.save
      render json: score
    else
      render json: { error: "Failed to create score"}
    end
  end

  private

  def create_params
    # TODO
    # requestee_id, requester_id = params.require(
    #   [:requestee_id, :requester_id]
    # )
    # { requestee_id: requestee_id, requester_id: requester_id }
  end
end
