class CreateCaptchas < ActiveRecord::Migration[5.2]
  def change
    create_table :captchas do |t|
      t.text :request_params
      t.integer :captcha_sid
      t.text :captcha_img
      t.string :solution
      t.boolean :result

      t.timestamps
    end
  end
end
