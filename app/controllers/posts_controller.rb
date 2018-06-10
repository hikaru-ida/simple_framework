require 'net/http'
class PostsController < Controller
  def index
    @posts = Post.all
  end

  def new
    @posts = Post.all
  end

  def create
    title = self.params['title']
    content = self.params['content']
    Post.create(title: title, content: content)
    self.redirect_to = '/posts/new'
  end
end