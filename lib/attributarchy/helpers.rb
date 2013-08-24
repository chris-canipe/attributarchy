module Attributarchy
  module Helpers
    def build_attributarchy(attributarchy, data, level_index = 0)
      output ||= ''
      current_level = attributarchy[:attributes][level_index]
      data.group_by(&current_level).each_with_index do |(group_value, group_data), index|
        partial = "#{attributarchy[:partial_directory]}/#{current_level}"
        output << (
          render partial: partial, locals: {
            group_data: group_data,
            group_value: group_value,
            group_level: level_index
          }
        )
        if level_index < attributarchy[:attributes].count - 1
          output << build_attributarchy(attributarchy, data, level_index + 1)
        end
      end
      return output
    end
  end
end
