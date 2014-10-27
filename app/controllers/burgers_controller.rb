class BurgersController < ApplicationController
before_action :load_burger ,:check_animal

	def index
		@burgers = Burger.all
	end

	def new
		@burger = Burger.new(burger_params)

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

private

	def load_burger
		Burger.create(id:1, buns:"Extra Toasted") if Burger.where(id:1).empty?
	end

	def check_animal
		@burger = Burger.new
		animal = {onion1:"GR",frystyle:"mfd",spread:"X S",pickles:"P"}

		if params[:animalstyle] =="1"
			burger_params.merge(pickles:"P")
		end
	end

	def burger_params
		params.require(:burger).permit(:buns, :patties,
			:cheese, :onions, :tomatoes, :lettuce, :spreads,
			:others, :cutinhalf, :cooklevel, :heavymustardbeef,
			:normalmustardbeef, :normalbeef, :nosaltbeef, :meltcheese, :coldcheese,
			:rawwholeonions, :rawchoponions, :grillwholeonions, :grillchoponions,
			:sumbeef, :sumcheese, :sumonions, :spread, :mustard, :ketchup, :extrasalt,
			:pickles, :chopchillies, :condiments, :specialrequests, :animalstyle,
			:result, :code, :frystyle, :beefcount, :cheesestyle, :cheesecount, :onionstyle,
			:onioncount, :onion1, :onion2, :onion3, :onion4)
	end
end
