migration 2, :create_images do
  up do
    create_table :images do
      column :id, Integer, serial: true
      column :album_id, Integer, required: true
      column :file_uid, String
      column :file_name, String
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
  down do
    drop_table :images
  end
end
