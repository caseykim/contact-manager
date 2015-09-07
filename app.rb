require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

require_relative 'models/contact'
also_reload 'models/contact'

get '/' do
  page = params[:page] || 1
  @page = page.to_i
  offset = 5 * (@page - 1)

  @contacts = Contact.all.limit(5).offset(offset)
  erb :index
end

get '/contacts' do
  @query = params[:query]
  @contacts = Contact.where(
    "first_name LIKE :s OR
    last_name LIKE :s OR
    concat(first_name, ' ', last_name) LIKE :s",
    :s => "%#{@query}%")

  erb :result
end

get '/contacts/:id' do
  @contact = Contact.find(params[:id])
  erb :show
end

get '/new' do
  erb :new
end

post '/new' do
  Contact.create(params)
  redirect '/'
end
