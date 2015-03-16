class Book < ActiveRecord::Base
  extend ActiveRecord::StringEnum

  str_enum status: [:proposed, :written, :published]
  str_enum read_status: [:unread, :reading, :read]
  str_enum nullable_status: [:single, :married]

  def published!
    super
    "do publish work..."
  end
end
