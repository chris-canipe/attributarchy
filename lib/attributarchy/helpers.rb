module Attributarchy
  module Helpers
    def build_attributarchy(name, data, level_index = 0)
      output ||= ''
      output = %{<div class="attributarchy">} if level_index == 0 # Outermost wrapper
      current_level = attributarchy_configuration[name][level_index]
      data.group_by(&current_level).each_with_index do |(group_value, group_data), index|
        output << %{<div class="#{current_level}-container">}
        unless attributarchy_configuration[:without_rendering].has_key?(current_level)
          output << (
            # TODO: / desired?
            render_to_string partial: "/#{current_level}", locals: {
              group_data: group_data,
              group_value: group_value,
              group_level: level_index
            }
          )
        end
        if level_index < attributarchy_configuration[name].count - 1
          output << build_attributarchy(name, data, level_index + 1)
        end
        output << '</div>'
      end
      output << '</div>' if level_index == 0 # End outermost wrapper
      output.html_safe
    end
  end
end
