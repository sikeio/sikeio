class CreateCourseInvites < ActiveRecord::Migration
  def change
    create_table :course_invites do |t|
      t.string :token, null: false
      t.references :course

      t.timestamps null: false
    end

    add_index :course_invites, :token, unique: true
  end
end
