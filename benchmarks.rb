#! /usr/bin/env ruby
require 'rubygems'
require 'byebug'
require 'bundler/setup'
require 'active_record'
require 'action_controller'
require 'active_model_serializers'
require 'dotenv'
require 'benchmark'
require 'postgres_ext'
require 'postgres_ext/serializers/active_model'
Dotenv.load

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])

class PESArraySerializer < ActiveModel::ArraySerializer
  prepend PostgresExt::Serializers::ActiveModel::ArraySerializer
end

class TestController < ActionController::Base
  def url_options
    {}
  end
end

class Note < ActiveRecord::Base
  has_many :tags
  has_many :comments
end

class NotesController < TestController; end

class NoteSerializer < ActiveModel::Serializer
  attributes :id, :content, :title
  has_many   :tags
  has_many   :comments
  embed      :ids, include: true
end

class Tag < ActiveRecord::Base
  belongs_to :note
end

class TagSerializer < ActiveModel::Serializer
  attributes :id, :name
end

class Comment < ActiveRecord::Base
  belongs_to :note
end

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content
end

controller = NotesController.new
relation = Note.all.includes(tags: [:note], comments: [:note])
all_notes = Note.all.to_a
half_notes = Note.where(id: [1..500]).includes(tags: [ :note ], comments: [:note])
hundred_notes = Note.where(id: [1..100]).includes(tags: [ :note ], comments: [:note])
ten_notes = Note.where(id: [1..10]).includes(tags: [ :note ], comments: [:note])
one_notes = Note.where(id: 1).includes(tags: [ :note ], comments: [:note])

out = nil
Benchmark.bmbm do |x|

  x.report("All Records: AMS") do
      ActiveModel::Serializer.build_json(controller, relation, {}).to_json
  end

  x.report("1/2 Records: AMS") do
      ActiveModel::Serializer.build_json(controller, half_notes, {}).to_json
  end

  x.report("1/10th Records: AMS") do
      ActiveModel::Serializer.build_json(controller, hundred_notes, {}).to_json
  end

  x.report("1/100th Records: AMS") do
      ActiveModel::Serializer.build_json(controller, ten_notes, {}).to_json
  end

  x.report("1 Record: AMS") do
      ActiveModel::Serializer.build_json(controller, one_notes, {}).to_json
  end

  x.report("All Records: PES") do
      ActiveModel::Serializer.build_json(controller, relation, serializer: PESArraySerializer).to_json
  end

  x.report("1/2 Records: PES") do
      ActiveModel::Serializer.build_json(controller, half_notes, serializer: PESArraySerializer).to_json
  end

  x.report("1/10th Records: PES") do
      ActiveModel::Serializer.build_json(controller, hundred_notes, serializer: PESArraySerializer).to_json
  end

  x.report("1/100th Records: PES") do
      ActiveModel::Serializer.build_json(controller, ten_notes, serializer: PESArraySerializer).to_json
  end

  x.report("1 Record: PES") do
      ActiveModel::Serializer.build_json(controller, one_notes, serializer: PESArraySerializer).to_json
  end
end

debugger

true
