class SearchResult

  attr_accessor :number, :title, :url, :modtime, :description, :size

  #
  # Queries yandex server by a specific URL to find all the results. Converts XML results to
  # a paging results of Search Results.
  #
  def self.find(query, options={})
    return nil if query.nil? or query.empty?
    xml_doc = fetch_xml_doc(URI.escape(query), options)
    results = convert_to_results(xml_doc, options)
    return nil if results.nil?
    
    results.query = URI.unescape(query)
    portlet = find_search_engine_portlet(options)
    results.path = portlet.path 
      
    results
  end

  def self.parse_results_count(xml_doc)
    root = xml_doc.root
    count = root.elements['response/found[@priority="all"]']
    count ? count.text.to_i : 0
  end

  def self.parse_results(xml_doc)
    root = xml_doc.root
    return nil if root.elements['response/results/grouping/page'].nil?
    results = []
    cnt_page = root.elements['response/results/grouping/page'].attributes["first"].to_i
    root.elements.each('response/results/grouping/group/doc') do |doc|
      result = SearchResult.new
      result.number = cnt_page

      begin 
        result.title = doc.elements['title'].text
      rescue
        result.title = "Untitled"
      end

      begin
        result.url = doc.elements['url'].text.gsub(/^webds\//, "http://")
      rescue
        result.url = nil
      end

      begin
        result.modtime = Time.parse(doc.elements['modtime'].text)
      rescue
        result.modtime = nil
      end


      result.description = doc.elements['passages/passage'].to_s.gsub(/<hlword priority='strict'>/,"<strong>").gsub(/<\/hlword>/,"</strong>").gsub(/<passage>|<\/passage>/, "")
      
      begin
        result.size = doc.elements['size'].text
      rescue
        result.size = 0
      end
      
      
      cnt_page += 1
 
      results << result
    end
    results
  end

  def self.convert_to_results(xml_doc, options={})
    array = parse_results(xml_doc)
    return nil if array.nil?
    results = PagingResults.new(array)
    results.results_count = parse_results_count(xml_doc)
    results.num_pages = calculate_results_pages(results.results_count)
    results.start = options[:start] ? options[:start] : 0
    results
  end



  def self.calculate_results_pages(results_count)
    num_pages = results_count / 10
    num_pages = num_pages + 1 if results_count % 10 > 0
    num_pages
  end


  def self.build_mini_url(options, query)
    portlet = find_search_engine_portlet(options)
    url = "/#{portlet.collection_name}?text=#{query}&xml=yes"
    if options[:start]
      url = url + "&p=#{options[:start]}"
    end
    return url
  end

  def self.find_search_engine_portlet(options)
    portlet = YandexServerSearchEnginePortlet.new
    if options[:portlet]
      portlet = options[:portlet]
    end
    portlet
  end

  # Fetches the xml response from the yandex server server.
  def self.fetch_xml_doc(query, options={})
    portlet = find_search_engine_portlet(options)
    # Turns off automatic results filter (filter=0), which when set to 1, allows mini to reduces the # of similar/duplicate results,
    # but makes it hard to determine the total # of results.
    url = build_mini_url(options, query)
    response, data = Net::HTTP.start(portlet.service_hostname, portlet.service_port_number) {|http|
        http.get(url)
    }
    xml_doc = REXML::Document.new(data)
    return xml_doc
  end


  class PagingResults < Array

    attr_accessor :results_count, :num_pages, :current_page, :start, :query, :pages
    attr_writer :path

    def path
      @path ? @path : "/search/search-results"
    end


    def next_page?
      next_start < num_pages
    end

    def previous_page?
      previous_start >= 0 && num_pages > 1
    end

    def pages
      if num_pages > 1
        return (1..num_pages)
      end
      []
    end

    def next_start
      start + 1
    end

    def previous_start
      start - 1
    end
    
    def current_page?(page_num)
      (page_num - 1 == start )
    end

    def current_page
      return page = start + 1 if start
      1
    end

    def next_page_path
      "#{path}?query=#{query}&start=#{next_start}"
    end

    def previous_page_path
      "#{path}?query=#{query}&start=#{previous_start}"
    end

    def page_path(page_num)
      "#{path}?query=#{query}&start=#{page_num - 1}"
    end
  end


end