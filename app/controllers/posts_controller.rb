require 'net/http'
class PostsController < Controller
  def index
    @posts = Post.all
  end

  def new
    @posts = Post.all
  end

  def create
    p self.params['post']
    #title = self.params['title']
    #content = self.params['content']
    #Post.create(title: title, content: content)
    Post.create(post_params)
    self.redirect_to = '/posts/new'
  end

  def post_params
    self.params.require('post').permit('title')
  end
end