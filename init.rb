require 'dispatcher'
Dispatcher.to_prepare do
  ApplicationController.send(:include, LightweightLocale) unless ApplicationController.include?(LightweightLocale)
end