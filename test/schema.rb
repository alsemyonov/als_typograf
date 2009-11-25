ActiveRecord::Schema.define(:version => 0) do
  create_table :articles, :force => true do |t|
    t.string :title
    t.text :content, :skills, :achievements, :description,
      :foo, :bar, :baz
  end
end
