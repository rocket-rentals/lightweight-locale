module LightweightLocale
  
  def set_locale
    if I18n.locale = filter_available_locales(extract_locale_from_params)
      session[:locale] = I18n.locale
    else
      I18n.locale = (session[:locale] ||= (filter_available_locales(extract_locale_from_headers)||I18n.default_locale))
    end
  end

  def self.included(base)
    base.send(:append_before_filter, :set_locale)
    base.send(:helper, Helper)
  end
  
  private

  def extract_locale_from_params
    params[:locale]
  end
  
  def extract_locale_from_headers
    ((request.env['HTTP_ACCEPT_LANGUAGE']||'').scan(/^[a-z]{2}/)||[]).first
  end

  def filter_available_locales(locale)
    locale and I18n.available_locales.include?(locale.to_s.downcase.to_sym) ? locale : nil
  end

  module Helper
    def select_locale_tag
      select_tag(:locale, options_for_select(I18n.available_locales.map{ |l| [I18n.t(l, :default => l.to_s), l] }, (I18n.locale||I18n.default_locale).to_sym), :onchange => "location.href='?locale='+this.value;", :class => 'select-locale' )
    end
  end  
end
