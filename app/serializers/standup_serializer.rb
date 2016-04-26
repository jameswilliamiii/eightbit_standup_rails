class StandupSerializer < ActiveModel::Serializer
  attributes :id, :program_name, :remind_at
end
