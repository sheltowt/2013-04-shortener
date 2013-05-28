require 'sinatra'
require "sinatra/reloader" if development?
require 'active_record'
require 'pry'
$count = 0

configure :development, :production do
    ActiveRecord::Base.establish_connection(
       :adapter => 'sqlite3',
       :database =>  'db/dev.sqlite3.db'
     )
end

# Quick and dirty form for testing application
#
# If building a real application you should probably
# use views: 
# http://www.sinatrarb.com/intro#Views%20/%20Templates
form = <<-eos
    <form id='myForm'>
        <input type='text' name="url">
        <input type="submit" value="Shorten"> 
    </form>
    <h2>Results:</h2>
    <h3 id="display"></h3>
    <script src="jquery.js"></script>

    <script type="text/javascript">
        $(function() {
            $('#myForm').submit(function() {
            $.post('/new', $("#myForm").serialize(), function(data){
                $('#display').html(data);
                });
            return false;
            });
    });
    </script>
eos

# Models to Access the database 
# through ActiveRecord.  Define 
# associations here if need be
#
# http://guides.rubyonrails.org/association_basics.html
class Link < ActiveRecord::Base

end

get '/jquery.js' do
    send_file 'jquery.js'
end

get '/:url' do
    p params[:url]
    print "ALL LINKS:"
    p Link.all
    #http://danneu.com/posts/15-a-simple-blog-with-sinatra-and-active-record-some-useful-tools/
    @link = Link.where(:short_link => params[:url]).first
    if @link
        redirect 'http://' + @link.long_link
    else
        halt 404
    end
end

get '/' do
    # add a link query for a link. see if we get errors
    form
end

post '/new' do
    p params
    @link = Link.where(:long_link => params[:url]).first
    if @link
        'inky.com/' + @link.short_link
    else
        $count += 1
        @link = Link.new(:long_link => params[:url], :short_link => $count.to_s)
        @link.save
        'inky.com/' + $count.to_s
    end
    #make a short link
    #add the short link to @link
    #return short link
    #@link.long_link
    # if @link.save
    #     redirect "/{@link.id}"
    # else
    #     puts "error"
    # end
    'inky.com/' + @link.short_link
end


####################################################
####  Implement Routes to make the specs pass ######
####################################################
