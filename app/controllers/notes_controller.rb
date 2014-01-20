class NotesController < ApplicationController
  def index
    @notes = Note.all.includes(:tags)

    render json: @notes
  end
end
