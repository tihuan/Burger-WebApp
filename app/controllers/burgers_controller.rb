class BurgersController < ApplicationController

	def index
		@burgers = Burger.all
	end

	def new
		@burger = Burger.new
	end

	def edit
		@burger = Burger.find(params[:id])
	end

	def create
		@burger = Burger.new(burger_params)

		if @burger.save
			redirect_to @burger
		else
			render 'new'
		end
	end

	def show
		@burger = Burger.find(params[:id])
	end

	def destroy
		@burger = Burger.find(params[:id])
		@burger.destroy
		redirect_to burgers_path
	end

	def update
		@burger = Burger.find(params[:id])
		if @burger.update(burger_params)
			redirect_to @burger
		else
			render 'edit'
		end
	end

	def animalstyle
		animalstyle_burger = Burger.create(pickles:"Pickles", spread: "Extra Spread", grillwholeonions:"1", normalmustardbeef:"2" )
	end



	private

	def burger_params
		params.require(:burger).permit(:buns, :patties, 
			:cheese, :onions, :tomatoes, :lettuce, :spreads, 
			:others, :cutinhalf, :cooklevel, :heavymustardbeef,
			:normalmustardbeef, :normalbeef, :nosaltbeef, :meltcheese, :coldcheese,
			:rawwholeonions, :rawchoponions, :grillwholeonions, :grillchoponions, 
			:sumbeef, :sumcheese, :sumonions, :spread, :mustard, :ketchup, :extrasalt,
			:pickles, :chopchillies, :condiments, :specialrequests, :animalstyle)
	end



end
