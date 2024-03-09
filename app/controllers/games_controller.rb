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

  def new_game_session(photo_id)
    session[:is_over] = false
    session[:did_update_start] = false
    session[:photo_id] = photo_id
    session[:object_count] = PhotoObject.where(photo_id: photo_id).count
    session[:found_object_ids] = []
    session[:start_in_ms] = (Time.now.to_f * 1000).to_i
    session[:end_in_ms] = -1
  end

  def update_game_session(args)
    return if session[:is_over]

    # update start time after client loads assets (images)
    unless args["did_update_start"]
      return if session[:did_update_start]
      return unless args["timestamp_in_ms"] > session[:start_in_ms]
      session[:start_in_ms] = args["timestamp_in_ms"]
      session[:did_update_start] = true
    end

    # return if player did not submit a guess
    object_id = args["object_id"]
    target_x = args["target_x"]
    target_y = args["target_y"]
    return unless (object_id && target_x && target_y)

    # return if player's guess does not identify an object
    photo_object = PhotoObject.find_by(id: object_id)
    return unless photo_object
    max_x = [photo_object.top_left_x, photo_object.bot_right_x].max
    min_x = [photo_object.top_left_x, photo_object.bot_right_x].min
    max_y = [photo_object.top_left_y, photo_object.bot_right_y].max
    min_y = [photo_object.top_left_y, photo_object.bot_right_y].min
    return unless min_x <= target_x && target_x <= max_x
    return unless min_y <= target_y && target_y <= max_y

    unless session[:found_object_ids].include?(object_id)
      session[:found_object_ids].push(object_id)
    end

    if session[:found_object_ids].size == session[:object_count]
      session[:end_in_ms] = args["timestamp_in_ms"]
      session[:is_over] = true
    end
  end
end
