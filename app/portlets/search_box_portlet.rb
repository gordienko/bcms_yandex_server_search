class SearchBoxPortlet < Portlet
    
  def render
    @search_engine = YandexServerSearchEnginePortlet.find_by_name(@portlet.search_engine_name)
    unless @search_engine
      raise "There is no Yandex-Server Search Engine Portlet with name = '#{@portlet.search_engine_name}'. You must create one for this portlet to work."
    end
  end
    
end