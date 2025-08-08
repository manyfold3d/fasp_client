FaspClient.configure do |conf|
  conf.authenticate = ->(request) do
    # Return a truthy value if the current user should be able to access and edit FASP providers, otherwise
    # return falsey. For example:
    #
    # Warden / Devise:
    # request.env["warden"]&.user&.is_administrator?
  end

  # Configure the layout name that should be used for views; defaults to "application"
  # conf.layout = "application"
end
