Tastyrb
=======

A thin wrapper for self-describing tastypie APIs

Parameters:

- `api_key`: Key to be passed to the server in GET array
- `api_key_param`: String name of the GET param to send the key as
- `base_uri`: The self-describing root of the api. When you change this, Tastyrb will redefine the methods it responds to.
- `jsonp_callback`: Not very useful, but there if you just want to return a raw jsonp string back to the browser
- `word_separator`: The character to use to convert paths to method calls. ex: '\_' would convert '/posts/latest/comments/' into posts\_latest\_comments()


Usage:

    api = Tastyrb::Client.new(base_uri='http://readthedocs.org/api/v1/')
    #=> #<Tastyrb::Client:0x007fa73a114c78 @resources=[:build, :file, :project, :user, :version], @api_key=nil, @api_key_param="api_key", @jsonp_callback=nil, @word_separator="_", @base_uri="http://readthedocs.org/api/v1/">
    api.file(:limit => 1)
    #=> [<#Tastyrb::Response absolute_url="/docs/django-instant-model/en/latest/index.html" ...>]