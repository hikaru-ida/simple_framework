class AddSomePosts < Sequel::Migration
  def up
    Post.create(
            title: 'What is Lorem Ipsum?',
            content: 'Lorem Ipsum is a dummy text...'
    )
  end

  def down
  end
end