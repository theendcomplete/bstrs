class AddRequestResponseIdToCaptcha < ActiveRecord::Migration[5.2]
  def change
    add_column :captchas, :request_response_id, :integer

  end
end
