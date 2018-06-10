class Controller
  attr_reader :name, :action, :params
  attr_accessor :status, :headers, :content, :redirect_to

  def initialize(name: nil, action: nil, method: nil, params: nil)
    @name = name
    @action = action
    @redirect_to = nil
    @params = params
    if(method != "GET")
      @return_template = false
    else
      @return_template = true
    end
  end

  def call
    send(action)
    self.status = 200
    self.headers = {"Content-Type" => "text/html"}
    if @return_template
      self.content = [template.result(binding)]
    else
      self.content = []
    end
    self
  end

  def template
    filename = File.read(File.join(SimpleApp.root, 'app', 'views', "#{self.name}", "#{self.action}.html.erb"))
    ERB.new(filename)
    #Slim::Template.new(File.join(App.root, 'app', 'views', "#{self.name}", "#{self.action}.slim"))
  end

  def not_found
    self.status = 404
    self.headers = {}
    self.content = ["Nothing found"]
    self
  end

  def internal_error
    self.status = 500
    self.headers = {}
    self.content = ["Internal error"]
    self
  end

end