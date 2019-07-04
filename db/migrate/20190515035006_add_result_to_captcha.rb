class AddResultToCaptcha < ActiveRecord::Migration[5.2]
  def change
    rename_column :captchas, :result, :is_valid
    add_column :captchas, :result, :text
  end
end
