class TagSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :note
  embed :ids
end
