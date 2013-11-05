Paperclip.options[:log] = false
Paperclip.options[:command_path] = if Rails.env.dev?
  "/usr/local/bin"
else
  "/usr/bin"
end

PAPERCLIP_OPTIONS = {
  :hash_secret => "B6692AD1-87A6-4792-9B7D-3AF38864486D",
  :default_url => "http://placehold.it/:style",
  :processors  => [:thumbnail]
}

PAPERCLIP_STORAGE_OPTIONS = if Rails.env.staging? || Rails.env.production?
  name = ProjectName::Application.name.downcase.gsub(/ /, "_") # underscore ?
  {
    :storage => :s3,
    :s3_credentials => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :bucket => ENV['FOG_DIRECTORY'],
    },
    :path => "#{name}/:class/:attachment/:id_partition/:style/:hash.:extension"
  }
else
  {
    :path => ":rails_root/public/system/:class/:attachment/:id_partition/:style/:hash.:extension",
    :url => "/system/:class/:attachment/:id_partition/:style/:hash.:extension"
  }
end

PAPERCLIP_OPTIONS.merge!(PAPERCLIP_STORAGE_OPTIONS)
