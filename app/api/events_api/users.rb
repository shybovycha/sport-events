module EventsApi
  class Users < Grape::API
    format :json
    content_type :json, 'application/json; charset=utf-8'

    resource :users do
      desc "test"
      params do
        requires :moo, type: String
      end
      get '/' do
        { success: true, message: 'test ok' }
      end

      desc "registers a user"
      params do
        requires :name, type: String, desc: "user name"
        requires :email, type: String, desc: "email"
        requires :password, type: String, desc: "password"
        requires :password_confirmation, type: String, desc: "password confirmation"
      end
      post :sign_up do
        user = User.new(name: params[:name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])

        if user.save
          { success: true, api_key: user.api_key }
        else
          { success: false, message: user.errors.full_messages.join(' and ') }
        end
      end

      desc "logs a user in"
      params do
        requires :email, type: String, desc: "email"
        requires :password, type: String, desc: "password"
      end
      post :sign_in do
        user = User.find_by(email: params[:email])

        if user.present? and user.valid_password?(params[:password])
          { success: true, api_key: user.api_key }
        elsif user.blank?
          { success: false, message: "user not found" }
        else
          { success: false, message: "wrong username or password" }
        end
      end

      desc "logs a user in with facebook"
      params do
        requires :facebook_id, type: String, desc: "facebook user id"
        requires :email, type: String, desc: "email"
        requires :name, type: String, desc: "user name"
      end
      post :facebook_sign_in do
        user = FacebookUser.find_or_create_by(facebook_id: params[:facebook_id], email: params[:email], name: params[:name])

        if user.present?
          { success: true, api_key: user.api_key }
        else
          { success: false, message: "could not sign in with facebook" }
        end
      end

      desc "restores a session"
      params do
        requires :api_key, type: String, desc: "user' API key, stored in a local client's database"
      end
      post :restore_session do
        user = User.find_by(api_key: params[:api_key])

        if user.present?
          { success: true }
        else
          { success: false }
        end
      end
    end
  end
end
