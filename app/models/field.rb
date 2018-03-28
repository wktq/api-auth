class Field < ApplicationRecord
  self.inheritance_column = 'sti_type'

  belongs_to :form
  belongs_to :user

  def html
    case self.type
    when 'text' then
      return '<input class="form-control" type="text" />'
      値1と一致する場合に行う処理
    when 'radio' then
      return '<input class="form-control" type="radio" />'
    when 'textarea' then
      return '<textarea class="form-control">こんにちは</textarea>'
    else
      self.type
    end
  end
end
