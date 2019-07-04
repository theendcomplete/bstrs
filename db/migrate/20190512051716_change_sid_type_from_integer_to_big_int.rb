class ChangeSidTypeFromIntegerToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :captchas, :captcha_sid, :decimal
  end
end
