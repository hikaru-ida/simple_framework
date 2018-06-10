class Router
  attr_reader :routes

  METHODS = ['GET', 'POST', 'PUT', 'DELETE']
  def initialize(routes)
    @routes = routes
  end


  def resolve(env)
    path = env['REQUEST_PATH']
    method = env['REQUEST_METHOD']
    if METHODS.include?(method) && routes.key?(method) && routes[method].key?(path)
      params = Rack::Request.new(env).params
      p params
      ret = ctrl(routes[method][path], method, params).call
      if ret.redirect_to
        ctrl(routes["GET"][ret.redirect_to], "GET", params).call
      else
        ret
      end
    else
      Controller.new.not_found
    end

  rescue Exception => error
    puts error.message
    puts error.backtrace
    Controller.new.internal_error
  end

  private def ctrl(string, method, params)
    ctrl_name, action_name = string.split('#')
    klass = Object.const_get "#{ctrl_name.capitalize}Controller"
    klass.new(name: ctrl_name, action: action_name.to_sym, method: method, params: params)
  end
end