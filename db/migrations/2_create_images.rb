migration 2, :create_images do
  up do
    create_table :images do
      column :id, Integer, serial: true
      column :album_id, Integer, required: true
      column :uuid, String, required: true
      column :file_uid, String, length: 255
      column :file_name, String, length: 50
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
  down do
    drop_table :images
  end
end
