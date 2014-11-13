migration 1, :create_albums do
  up do
    create_table :albums do
      column :id, Integer, serial: true
      column :slug, String
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
  down do
    drop_table :albums
  end
end
