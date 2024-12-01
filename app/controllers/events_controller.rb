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
    @related_users = User.joins(:event_user_relations).where(event_user_relations: { event_id: @event.id })
  end

  def new
    @event = Event.new
  end

  def create
    params[:event][:organizer_id] = current_user.id
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event
    else
      flash.now[:error] = "Failed to save your event!"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    p @event.is_private
    p event_params[:is_private]
    going_public = @event.is_private && event_params[:is_private] == "false"
    p going_public
    if going_public
      puts "TODO Prompt user to confirm when making a private event public"
    end
    if @event.update(event_params)
      if going_public
        @event.event_user_relations.where(type: :EventInvitation).delete_all()
        @event.event_user_relations.where(type: :EventRequest).each do |request|
          # Create RSVP for the requesting user
          rsvp = Rsvp.new(user_id: request.user_id, event_id: request.event_id)
          # TODO Create specific controller action for accepting & rejecting 
          # requests & invitations to DRY up the code
          if ! (request.destroy && rsvp.save)
            puts "Failed to save RSVP!"
            rsvp.errors.full_messages.each do |msg|
              puts msg
              flash.now[:error] = msg
            end
          end
        end
      end
      redirect_to @event
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
      event.event_user_relations.delete_all
      event.delete
      flash[:notice] = "Your event \"#{event.title}\" has been deleted"

      organizer = User.find(event.organizer_id)
      redirect_to user_events_url(organizer.username), status: :see_other
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
