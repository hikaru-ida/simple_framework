class Hash
  # Railsのrequre, permit機能を模したもの
  # require('post').permit('title', content)
  # のように使う。


  def require(key)
    value = self[key]
    if !value.empty? || !value.nil?
      value
    end
  end


  def permit(*filters)
    params = self.class.new

    filters.each do |filter|
      permitted_filter(params, filter)
    end
    params
  end


  def permitted_filter(params, key)
    if has_key?(key)
      params[key] = self[key]
    end
    params
  end

end