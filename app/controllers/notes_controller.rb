class NotesController < ApplicationController
  respond_to :json
  def index
    @notes = Note.includes(:tags)

    puts GC.stat(:total_allocated_object)
    json = ActiveModel::Serializer.build_json(self, @notes, {}).to_json
    puts GC.stat(:total_allocated_object)
    respond_with json, root: 'test'
  end
end
