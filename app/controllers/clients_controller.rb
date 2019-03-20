class ClientsController < ApplicationController

	get '/clients/new' do 
		redirect_if_not_logged_in
		erb :'clients/new'
	end

	post '/clients' do
		redirect_if_not_logged_in
		if params[:business_name] != ""
			flash[:message] = "Client was successfully added."
			@client = Client.create(business_name: params[:business_name], address: params[:address], email: params[:email], website: params[:website], projects: params[:projects], user_id: current_user.id)
			redirect "/clients/#{@client.id}"
		else
			flash[:error] = "Please enter a business name for your client"
			redirect '/clients/new'
		end
	end

	get '/clients' do 
		@all_clients = Client.all
		@clients = @all_clients.collect {|client| client.user_id == current_user.id}
		if !@clients
		erb :'clients/index'
		else
		flash[:error] = "Your clients list is currently empty"
		redirect "users/#{current_user.id}"
	end

	end

	get '/clients/:id' do
		redirect_if_not_logged_in 
		set_client
		erb :'clients/show'
	end

	get "/clients/:id/edit" do
		set_client
		redirect_if_not_logged_in
			if authorized_to_edit?(@client)
				erb :'clients/edit'
			else
				redirect "users/#{current_user.id}"
			end
	end

	patch '/clients/:id' do 
		set_client
		redirect_if_not_logged_in
			if authorized_to_edit?(@client) && params[:business_name] != ""
				@client.update(title: params[:params])
				redirect "/clients/#{@client.id}"
			else
				redirect "users/#{current_user.id}"
			end
	end

	delete '/clients/:id' do 
		set_client
		if authorized_to_edit?(@client)
			@client.destroy
			flash[:message] = "Your client record was successfully deleted."
			redirect "/clients"

		else
			redirect "/clients"
		end
	end

	private

	def set_client
		@client = Client.find(params[:id])
	end
end