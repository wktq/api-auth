class UserThingsController < ApplicationController
  before_action :set_user_thing, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  # GET /user_things
  # GET /user_things.json
  def index
    @user_things = current_user.user_things
  end

  # GET /user_things/1
  # GET /user_things/1.json
  def show
  end

  # POST /user_things
  # POST /user_things.json
  def create
    @user_thing = UserThing.new(user_thing_params)

    if @user_thing.save
      render :show, status: :created, location: @user_thing
    else
      render json: @user_thing.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_things/1
  # PATCH/PUT /user_things/1.json
  def update
    if @user_thing.update(user_thing_params)
      render :show, status: :ok, location: @user_thing
    else
      render json: @user_thing.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_things/1
  # DELETE /user_things/1.json
  def destroy
    @user_thing.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_thing
      @user_thing = UserThing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_thing_params
      params.require(:user_thing).permit(:name, :user_id)
    end
end
