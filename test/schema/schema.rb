ActiveRecord::Schema.define do
  create_table :books, force: true do |t|
    t.column :status, :string, default: 'proposed'
    t.column :read_status, :string, default: 'unread'
    t.column :nullable_status, :string
  end
end
