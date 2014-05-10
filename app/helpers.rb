module Helpers
  def admin_mode?
    @user && @user.is_admin?
  end

  def nice_list(arr, separator = ', ', connector = ' and ', oxford_comma = true)
    if arr.empty?
      ''
    elsif arr.size == 1
      arr.first.to_s
    else
      connector = (separator << connector).gsub!(/ +/, ' ') if oxford_comma and arr.size > 2
      [arr[0...-1].join(separator), arr.last].join(connector)
    end
  end

  def get_message(target = nil)
    if @user_message and @user_message_target == target
      message = @user_message
    elsif cookies[:message] and cookies[:message_target] == target
      message = cookies[:message]
    end

    if message
      '<div class="message cf">' << message << '<a href="#" class="js-close right">Close</a></div>'
    else
      ''
    end
  end

  def set_tmp_cookie(opts)
    opts.each do |(k, v)|
      cookies[k.to_sym] = v
      @tmp_cookie_keys.push k.to_sym
    end
  end

  def build_error_message(model, attribute_aliases = {})
    message = 'Uh oh, that didn\'t quite work. '
    model.errors.messages.each do |(attr, errors)|
      message << "#{(attribute_aliases[attr] || attr).capitalize} #{nice_list errors}. "
    end
    message << 'Please try again.'
  end
end