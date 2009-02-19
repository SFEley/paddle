module Merb
  module GlobalHelpers
    # helpers defined here available to all views.  
    
    # Takes the message passed by Merb or as a parameter and wraps it in CSS for styling. 
    # Handles both hash-style and string-style messages. 
    def styled_message(text = nil)
      text ||= message
      if !text.blank?
        tag :div, :class => "message" do  # I assume it'll become 'flash' again in Rails 3
          if text.is_a?(Hash)
            text.each{|key, value| puts tag(:div, h(value.to_s), :class => "#{h(key)}")}
          else
            tag :div, h(text.to_s), :class => "notice"
          end
        end
      end
    end
    
  end
end
