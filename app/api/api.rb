class API < Grape::API
  prefix :api

  mount EventsApi::Users
  mount EventsApi::Events
end