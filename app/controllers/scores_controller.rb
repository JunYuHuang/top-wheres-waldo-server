class ScoresController < ApplicationController
  def index
    scores = Score
      .select(:id, :player_name, :run_length_in_ms)
      .where(photo_id: params[:photo_id])
      .order(run_length_in_ms: :asc)
    return render json: scores if params[:all]

    render json: scores.limit(5)
  end

  def create
    unless does_game_session_exist?
      render json: {
        error: {
          title: "Failed to create score",
          message: "Game session does not exist"
        }
      }
      return
    end

    unless is_game_session_over?
      render json: {
        error: {
          title: "Failed to create score",
          message: "Game session is not over"
        }
      }
      return
    end

    score = Score.new(
      photo_id: session[:photo_id],
      player_name: create_params[:player_name],
      run_length_in_ms: session[:end_in_ms] - session[:start_in_ms]
    )
    if score.save
      render json: score
    else
      # TODO - send HTTP status 500?
      render json: {
        error: {
          title: "Failed to create score",
          message: "Failed to save score in database"
        }
      }
    end
  end

  private

  def create_params
    params.permit(:player_name)
  end
end
