module BootstrapFlashHelper
  #ALERT_TYPES = [:error, :info, :success, :warning]
  ALERT_TYPES = {
    notice: :success,
    alert: :error
  }

  #def bootstrap_flash
    #flash_messages = []
    #flash.each do |type, message|
       #Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      #next if message.blank? # In my opinion this would get confusing as i would wonder why my flash wasn't appearing
      
      #type = :success if type == :notice
      #type = :error   if type == :alert
      #next unless ALERT_TYPES.include?(type) # same with this. Fail harder. Let me know why my flash isn't appearing

      #Array(message).each do |msg| # it seems weird to pass an array to message
        #text = content_tag(:div,
                           #content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           #msg.html_safe, :class => "alert fade in alert-#{type}") # I know this isn't html in a helper... but it really is
        #flash_messages << text if message
      #end
    #end
    #flash_messages.join("\n").html_safe
  #end

  def bootstrap_flash
    flash.each do |type, message|
      render partial: "/layouts/flash", locals: { type: type, message: message }
    end
  end
end
