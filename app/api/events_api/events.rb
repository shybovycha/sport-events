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
        format_with(:iso_timestamp) { |dt| dt.iso8601 }

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
        end

        def self.format(collection)
          collection.map { |e| Entities::Event.new(e) }
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
        requires :lat, type: Float, desc: "center latitude"
        requires :lng, type: Float, desc: "center longitude"
        requires :radius, type: Float, desc: "distance from center to search for, km"
        optional :sports, type: String, desc: "sport types to search for"
      end
      get '/' do
        if params[:sports].present?
          events = Event.where(:sport => params[:sports].split(','))
        else
          events = Event.all
        end

        events = events.near [ params[:lat].to_f, params[:lng].to_f ], params[:radius].to_f, :units => :km

        { success: true, events: Entities::Event.format(events) }
      end

      desc "creates an event"
      params do
        requires :api_key, type: String, desc: "API key"
        requires :title, type: String, desc: "Event title"
        requires :description, type: String, desc: "Event description"
        requires :address, type: String, desc: "Address, or where the event will be going"
        requires :sport, type: String, desc: "Event' sport type"
      end
      post '/create' do
        authenticate!

        event = Event.new title: params[:title], description: params[:description], address: params[:address], sport: params[:sport]

        if event.save and get_user.events << event
          { success: true, event_id: event.id }
        else
          { success: false, message: event.errors.full_messages.join('; ') }
        end
      end
    end
  end
end