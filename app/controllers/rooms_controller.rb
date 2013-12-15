class RoomsController < ApplicationController


	def index
		@rooms = Room.all
	end

	def new
		@room = Room.new
	end

	def edit
		@room = Room.find(params[:id])
	end

	def create
		@room = Room.new(params[:room].permit[:name, :description])

		if @room.save
			redirect_to @room
		else
			render 'new'
		end
	end

	def show
		@room = Room.find(params[:id])
	end

	def destroy
		@room = Room.find(params[:id])
		@room.destroy
		redirect_to rooms_path
	end

	def go(direction)
		@paths[direction]
	end

	def add_paths(paths)
		@paths.update(paths)
	end

	def update
		@room = Room.find(params[:id])

		if @room.update(params[:room].permit(:name, :description, :paths, :directions, :commands, :scanresults))
			redirect_to @room
		else
			render 'edit'
		end
	end

	private



end
