module Pagination
  def pagination_browse
    @prev = button "< prev" do
      load_repo(@page - 1)
    end
    
    @page_widget = stack :width => 25 do
      @page_display = para @page, :stroke => green, :width => 25, :align => "center"
      # click { @pagination.clear &method(:pagination_jump) }
    end
    
    @next = button "next >" do
      load_repo(@page + 1)
    end
  end
  
  def pagination_jump
    @prev = button "cancel" do
      @pagination.clear &method(:pagination_browse)
    end
    
    @page_jump = edit_line @page, :width => 25
    @page_jump.focus
    
    @jump = button "jump >" do
      if @page_jump.text =~ /^\d+$/
        if commits_for_page(@page_jump.text.to_i).any?
          load_repo(@page_jump.text.to_i)
          @pagination.clear &method(:pagination_browse)
        else
          alert "No commits for page #{@page_jump.text}!"
        end
      else
        alert "Page #{@page_jump.text}!? Pff."
      end
    end
  end
end
