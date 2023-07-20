module ApplicationHelper
  def t_name
    Zeitwerk::Loader.eager_load_all
    ApplicationRecord.descendants.collect { |type| type.name if type.name!= "User"}.compact
  end
end
