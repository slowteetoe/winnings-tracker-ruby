module WinningsTracker
  class APIv1 < Grape::API
    version 'v1', using: :path
    format :json
    default_format :json

    resources :locations do
      get do
        [
          { id: 1, name: "hello world" },
          { id: 2, name: "hola mundo"}
        ]
      end
    end

  end
end
