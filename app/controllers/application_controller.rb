class ApplicationController < ActionController::API
  def is_game_session_over?
    return false if session[:is_over].nil?
    session[:is_over]
  end

  def does_game_session_exist?
    return false if session[:session_id].nil?
    return false if session[:did_update_start].nil?
    return false if session[:photo_id].nil?
    return false if session[:object_count].nil?
    return false if session[:found_object_ids].nil?
    return false if session[:start_in_ms].nil?
    return false if session[:end_in_ms].nil?
    true
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

  # For testing only
  def fake_done_game_session
    session[:is_over] = true
    session[:did_update_start] = true
    session[:photo_id] = 1
    session[:object_count] = 3
    session[:found_object_ids] = [1, 2, 3]
    session[:start_in_ms] = 1710012004717
    session[:end_in_ms] = 1710012021529
  end
end
