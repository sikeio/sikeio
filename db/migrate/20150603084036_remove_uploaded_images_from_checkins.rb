class RemoveUploadedImagesFromCheckins < ActiveRecord::Migration
  def change
    remove_column :checkins, :uploaded_images
  end
end
