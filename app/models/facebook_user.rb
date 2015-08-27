class FacebookUser
  def self.find_or_create_by(params = {})
    facebook_id = params[:facebook_id]
    email = params[:email]
    name = params[:name]

    user = User.find_by(facebook_id: facebook_id)

    if user.blank?
      password = SecureRandom.hex
      user = User.create(facebook_id: facebook_id, email: email, name: name, password: password, password_confirmation: password)

      if user.errors.present?
        Rails.logger.error "Could not create user because of:"
        Rails.logger.error user.errors.full_messages
      end
    end

    user
  end
end
