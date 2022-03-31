UUID_REGEXP = /[0-9a-f]{8}-[0-9a-f]{3,4}-[0-9a-f]{4}-[0-9a-f]{3,4}-[0-9a-f]{12}/.freeze

Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth::MultiProvider.register(
    self,
    provider_name: :saml,
    identity_provider_id_regex: UUID_REGEXP,
    path_prefix: '/saml',
    callback_suffix: 'callback',
  ) do |identity_provider_id, rack_env|
    request = Rack::Request.new(rack_env)
    idp = IdentityProvider.find_by_uid(identity_provider_id.chomp('/callback'))
    OneLogin::RubySaml::IdpMetadataParser.new.parse_to_hash(
      idp.metadata.download
    ).merge(
      { assertion_consumer_service_url: acs_url(request.url) }
    )
  end

  def acs_url(request_url)
    url = request_url.chomp('/callback')
    url + '/callback'
  end
end