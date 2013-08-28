module Attributarchy
  module Helpers
    def build_attributarchy(attributarchy, name, data, level_index = 0)
      output ||= ''
      output = %{<div class="attributarchy">} if level_index == 0 # Outermost wrapper
      current_level = attributarchy[name][level_index]
      data.group_by(&current_level).each_with_index do |(group_value, group_data), index|
        partial = "#{attributarchy[:partial_directory]}/#{current_level}"
        output << %{<div class="#{current_level}-container">}
        output << (
          render partial: partial, locals: {
            group_data: group_data,
            group_value: group_value,
            group_level: level_index
          }
        )
        if level_index < attributarchy[name].count - 1
          output << build_attributarchy(attributarchy, name, data, level_index + 1)
        end
        output << '</div>'
      end
      output << '</div>' if level_index == 0 # End outermost wrapper
      output
    end
  end
end
