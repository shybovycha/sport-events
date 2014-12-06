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
        expose :sport

        expose :user, as: :author, using: Entities::User

        with_options(format_with: :iso_timestamp) do
          expose :created_at
        end

        def self.format(collection)
          collection.map { |e| Entities::LostAlert.new(e) }
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
        optional :sports, type: Array, desc: "sport types to search for"
      end
      get '/' do
        if params[:sports].present?
          events = Event.where(:sport => params[:sports])
        else
          events = Event.all
        end

        events = events.near [ params[:lat].to_f, params[:lng].to_f ], params[:radius].to_f, :units => :km

        { success: true, events: events }
      end
    end
  end
end