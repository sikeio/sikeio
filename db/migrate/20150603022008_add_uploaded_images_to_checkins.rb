class AddUploadedImagesToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :uploaded_images, :string, array: true, default: []
  end
end
