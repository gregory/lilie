class AlbumRepresenter < BaseRepresenter
  property :slug
  property :created_at
  property :updated_at

  link :self do |opts| "#{opts[:api_endpoint]}/albums/" end
end
