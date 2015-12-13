module EventsApi
  class Events < Grape::API
    format :json
    content_type :json, 'application/json; charset=utf-8'

    module Entities
      # User entity
      class User < Grape::Entity
        expose :name
      end

      # Base entity
      class Event < Grape::Entity
        format_with(:iso_timestamp) { |dt| dt.strftime(::Event::DATE_FORMAT) }

        expose :id
        expose :title
        expose :description
        expose :lat
        expose :lng
        expose :address
        expose :sport

        expose :users, as: :visitors, using: Entities::User

        with_options(format_with: :iso_timestamp) do
          expose :created_at
          expose :starts_at
        end

        def self.format(collection)
          collection.map { |e| Entities::Event.new(e) }
        end
      end

      class GroupedEvent < Event
        expose :group

        def self.format(collection)
          collection.map { |e| Entities::GroupedEvent.new(e) }
        end
      end
    end

    helpers do
      def get_user
        unless @current_user.present?
          if params[:api_key].present?
            @current_user = User.find_by(api_key: params[:api_key])
          end
        end

        @current_user
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless get_user
      end
    end

    resource :events do
      desc "gets all the events for the specified query params"
      params do
        requires :address, type: String, desc: "user's address, to search around it"
        optional :radius, type: Float, desc: "distance from center to search for, km"
        optional :sports, type: String, desc: "sport types to search for"
        optional :query, type: String, desc: "a set of keywords to search in events' titles"
        optional :group_by, type: String, desc: "grouping field"
      end
      get '/' do
        events = Event.by_sports(params[:sports])
#          .by_address(params[:address], params[:radius])

        events = EventsFormatter.new(events)
          .grouped_by(params[:group_by])
          .relevant_to(params[:query])
          .events

        { success: true, events: Entities::GroupedEvent.format(events) }
      end

      desc "gets all the events for the specified user"
      params do
        requires :api_key, type: String, desc: "API key"
        optional :group_by, type: String, desc: "grouping field"
      end
      get :for_user do
        events = EventsFormatter.new(get_user.events)
          .grouped_by(params[:group_by])
          .events

        { success: true, events: Entities::GroupedEvent.format(events) }
      end

      desc "creates an event"
      params do
        requires :api_key, type: String, desc: "API key"
        requires :title, type: String, desc: "Event title"
        requires :description, type: String, desc: "Event description"
        requires :address, type: String, desc: "Address, or where the event will be going"
        requires :sport, type: String, desc: "Event' sport type"
        requires :starts_at, type: String, desc: "Event' start date and time"
      end
      post '/create' do
        authenticate!

        event = Event.new title: params[:title], description: params[:description], address: params[:address], sport: params[:sport], starts_at: params[:starts_at]

        if event.save and get_user.events << event
          { success: true, event_id: event.id }
        else
          { success: false, message: event.errors.full_messages.join('; ') }
        end
      end

      desc "joins current user to an event"
      params do
        requires :api_key, type: String, desc: "API key"
        requires :event_id, type: String, desc: "Event ID to be joined to"
      end
      get '/join' do
        event = Event.find(params[:event_id])
        current_user = get_user

        if event and event.users << current_user
          { success: true }
        else
          { success: false }
        end
      end

      desc "leaves current user from an event"
      params do
        requires :api_key, type: String, desc: "API key"
        requires :event_id, type: String, desc: "Event ID to be left"
      end
      get '/leave' do
        event = Event.find(params[:event_id])
        current_user = get_user

        if event and event.users.delete current_user
          { success: true }
        else
          { success: false }
        end
      end
    end
  end
end
