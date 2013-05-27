require 'sinatra'
require "sinatra/reloader" if development?
require 'active_record'
require 'pry'

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


get '/' do
    #http://danneu.com/posts/15-a-simple-blog-with-sinatra-and-active-record-some-useful-tools/
    @link = Link.find(params[:id])
    redirect "/{@link.long_link}"
    @long_link = @link.long_link
    erb '/' + @link.short_link.split('/')[1]
end

get '/test' do
    # add a link query for a link. see if we get errors
    Link.create()
end

post '/new' do
    "hello"
    # @link = Link.new(params[:short_link])
    # puts @link
    # if @link.save
    #     erb "hello world"
    #     redirect "/{@link.id}"
    # else
    #     puts "error"
    # end
    # erb "Hello WOrld"
    # PUT CODE HERE TO CREATE NEW SHORTENED LINKS
end

get '/jquery.js' do
    send_file 'jquery.js'
end

####################################################
####  Implement Routes to make the specs pass ######
####################################################
