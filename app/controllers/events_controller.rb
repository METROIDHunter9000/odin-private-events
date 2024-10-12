class EventsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :authorize_user, only: [:update, :destroy]

  def index
    if params[:user_username]
      @user = User.find_by(username: params[:user_username])
      @events = Event.where(organizer_id: @user.id)
      render "users/index_events"
    else
      @events = Event.all
    end
  end

  def show
    @event = Event.find(params[:id])
    @attendees = Rsvp.where(event_id: @event.id).map { |rsvp| User.find(rsvp.user_id) } 
  end

  def new
    @event = Event.new
  end

  def create
    params[:event][:organizer_id] = current_user.id
    @event = Event.new(event_params)
    if @event.save
      redirect_to action: :show, id: @event.id
    else
      flash.now[:error] = "Failed to save your event!"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    event = Event.find(params[:id])
    if event.update(event_params)
      redirect_to action: :show, id: @event.id
    else
      flash.error = "Failed to update your event!"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    event = Event.find(params[:id])
    if current_user.id != event.organizer_id
      head :forbidden
    else
      # Remove all attendees
      Rsvp.where(event_id: event.id).delete_all
      event.delete
      flash[:notice] = "Your event \"#{event.title}\" has been deleted"

      organizer = User.find(event.organizer_id)
      redirect_to "/users/#{organizer.username}/events", status: :see_other
    end
  end

  private
  def event_params
    params.require(:event).permit(:title, :body, :organizer_id, :date, :is_private)
  end

  def authorize_user
    event = Event.find(params[:id])
    if current_user.id != event.organizer_id
      flash[:error] = "You are not permitted to modify other people's events"
      redirect_to "/", status: :see_other
    end
  end
end
