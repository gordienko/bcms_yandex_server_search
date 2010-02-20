# Yandex-Server Search Module

This module allows BrowserCMS to integrate with a Yandex-Server Search Appliance. Yandex-Server is a standalone search
server, which can be configured to crawl your website. This module submits queries to a Yandex-Server server, and formats the results.
It consists of the following two portlets.

1. Search Box - Displays an input box that submits a search query.
2. Yandex-Server Search Results Portlet - Sends query to the Yandex-Server, formats the XML response and displays the results.

Note: This module assume the BrowserCMS web site owner has access to their own Yandex-Server server, either hosted by
themselves or a third party service.

## A. Instructions
There are two basic steps to setting up this module:

1. Configure your Yandex-Server to crawl your site.
2. Install the module and configure it to point to your Yandex-Server server.

These instructions assume the Yandex-Server is already set up and running.

### B. Configuring Yandex-Server
Configuring the mini include three basic steps, configuring it to crawl your site, creating a collection which limits
what is returned to just your site, and creating a front end, which allows you to submit search queries.

#### B.1. Configuring the dsindexer.cfg

<collection id="www.mysite.com"  autostart="yes">
    IndexDir : /usr/local/yandex/var/www.mysite.com
    TempDir :  /usr/local/yandex/var/www.mysite.com.tmp
    <IndexLog>
        FileName : /usr/local/yandex/var/www.mysite.com-index.log
        Level : moredebug verbose
    </IndexLog>
    <DataSrc id="webds">
        <Webds>
            StartUrls : http://adm-new.anadyr.org
            <Extensions>
                text/html : .html, .htm, .shtml
                text/xml : .xml
                application/pdf : .pdf
                application/msword : .doc
            </Extensions>
        </Webds>
    </DataSrc>
    <DocFormat>
        MimeType : text/html
    </DocFormat>
    <DocFormat>
        MimeType : text/xml
    </DocFormat>
    <DocFormat>
        MimeType : application/pdf
    </DocFormat>
    <DocFormat>
        MimeType : application/msword
    </DocFormat>
</Collection>

#### B.2. Configuring the collection yandex.cfg

<Server>
    Port : 17000
    Host : yandex-server.mysite.com
    Threads : 4
    QueueSize : 20
    WorkDir  /usr/local/yandex
    ServerLog   /usr/local/yandex/var/yandex.log

    <Authorization>
        UserName : admin	
        UserPassword : xxxxxxxxx
    </Authorization>
</Server>

<Collection id="www.mysite.com"  autostart="yes">
    IndexDir : /usr/local/yandex/var/www.mysite.com
    TempDir :  /usr/local/yandex/var/www.mysite.com.tmp
    <IndexLog>
        FileName : /usr/local/yandex/var/www.mysite.com-index.log
        Level : moredebug verbose
    </IndexLog>
    <DataSrc id="webds">
        <Webds>
            StartUrls : http://www.mysite.com
            <Extensions>
                text/html : .html, .htm, .shtml
                text/xml : .xml
                application/pdf : .pdf
                application/msword : .doc
            </Extensions>
        </Webds>
    </DataSrc>
    <DocFormat>
        MimeType : text/html
    </DocFormat>
    <DocFormat>
        MimeType : text/xml
    </DocFormat>
    <DocFormat>
        MimeType : application/pdf
    </DocFormat>
    <DocFormat>
        MimeType : application/msword
    </DocFormat>
</Collection>

#### B.3. Run dsindexer
$ dsindexer dsindexer.cfg

At this point, you should have the Yandex-Server appliance configured.

### C. Configuring the BrowserCMS Yandex-Server Search Module
These instructions assume you have successfully installed the bcms_yandex_server_search module into your project. To make
the module work, you will have to configure two portlets.

1. In your sitemap, create a new section called 'Search', with a path '/search'.
2. Create a page called 'Search Results', with a path '/search/search-results'.
3. On that page, add a new 'Yandex-Server Search Engine' portlet. Keep the default for most fields.
4. In the Service hostname, field, enter in the domain name to your Yandex-Server server (i.e.  yandex-server.mysite.com).
5. In the Service port number field, enter the Yandex-Server port number(i.e. 17000)
6. In the Collection Name field, enter the same name you gave your collection in B.2.2. (i.e. www.mysite.com)
7. Make sure the 'path' attribute is the same as the page you are adding  the portlet to (i.e. /search/search-results
8. Save the portlet
9. On another page create a Search Box portlet (alternatively, you can create the portlet and add it your templates via render_portlet)
10. Set the 'Search Engine Name' field to the exact same name as the portlet in step C.3 above (i.e. Yandex-Server Search Engine)
11. Save the portlet

At this point, you can test the search by entering in a term to the Search Box portlet. If its working, it should call
the Search Results page and display the same results as what you see in the http://yandex-server.mysite.com/www.mysite.com. You can style the HTML in
the template to tweak how your search results will work.
