class FavoritesController < ApplicationController
  before_action :set_favorite, only: [:show, :update, :destroy]
  before_action :authenticate_user!
  # GET /favorites
  # GET /favorites.json
  def index
    @favorites = current_user.favorites
  end

  # GET /favorites/1
  # GET /favorites/1.json
  def show
  end

  # POST /favorites
  # POST /favorites.json
  def create
    @favorite = Favorite.new(favorite_params)

    if @favorite.save
      render :show, status: :created, location: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /favorites/1
  # PATCH/PUT /favorites/1.json
  def update
    if @favorite.update(favorite_params)
      render :show, status: :ok, location: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.json
  def destroy
    @favorite.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite
      @favorite = Favorite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_params
      params.require(:favorite).permit(:task_id)
    end
end
