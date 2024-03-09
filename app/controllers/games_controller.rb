=begin
  Notes:
  - The `Games` controller only updates the session (stored on the client as a cookie) associated with the client.
  - There is no associated `Game` model or `games` database table.
  - The `id` param passed for all action methods is ignored because the session for each client that connects the backend is uniquely identified by their session id.
=end

class GamesController < ApplicationController
  # only used for testing
  def show
    render json: session
  end

  def create
    new_game_session(params[:photo_id])
    render json: session
  end

  def update
    update_game_session(update_params)
    render json: session
  end

  def destroy
    reset_session
    render json: session
  end

  private

  def update_params
    permitted = params.permit(
      :object_id,
      :target_x,
      :target_y,
      :timestamp_in_ms,
      :did_update_start
    )
  end
end
