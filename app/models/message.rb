class Message < ApplicationRecord
  extend Enumerize
  enumerize :type, in: [:normal, :proposal], default: :normal
  self.inheritance_column = :_type_disabled # この行を追加

  belongs_to :user
  belongs_to :room

  def created_ago
    if self.created_at.to_i - DateTime.now.to_i < 1440
      if ((DateTime.now.to_i - self.created_at.to_i) / 60) < 1
        return (DateTime.now.to_i - self.created_at.to_i).to_s + '秒前'
      elsif ((DateTime.now.to_i - self.created_at.to_i) / 60) < 60
        return ((DateTime.now.to_i - self.created_at.to_i) / 60).to_s + '分前'
      else
        return ((DateTime.now.to_i - self.created_at.to_i) / 3600).floor.to_s + '時間前'
      end
    else
      self.created_at.strftime('%m/%d %H:%M')
    end
  end
end
