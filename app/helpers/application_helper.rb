module ApplicationHelper

    def auth_token
       "<input type=\"hidden\" name=\"authenticity_token\" value=\"#{form_authenticity_token}\">".html_safe
    end

    def reset_sort_filter_button_text
        #helper method returning descriptive text on a reset button
        
        sorting_field = params[:filter][:sorting_field] == 'created_at' ? 'date' : 
                                                                  params[:filter][:sorting_field]
        order = params[:filter][:sorting_order] == 'asc' ? 'ascending' : 'descending'

        "Posts sorted by #{sorting_field},in #{order} order"
    end
end
