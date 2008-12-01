require "lib/colors"

class CommitListItem < Shoes::Widget
  include Colors
  
  attr_accessor :selected
  
  def initialize(commit, default_bg_color, options = {})
    @commit   = commit
    @selected = false
    
    @stack = stack
    
    @default_bg_color = default_bg_color
    
    draw_contents
  end
  
  def draw_contents
    @stack.clear do
      if @selected
        background green
      else
        background @default_bg_color
      end
    
      @hover_bg = background(green).hide unless @selected
    
      # size = 36
      # stack :width => size, :margin => [0,0,3,0] do
      #   image "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(@commit.author.email.downcase)}&s=#{size}",
      #     :width => size, :height => size
      # end
      
      stack :margin => (@commit.merge? ? 2 : 5) do # , :width => -(size + 5) do
        if @commit.merge?
          para @commit.message, :leading => 1, :size => base_font_size-2,
            :margin => [0,2,0,4], :weight => "bold"
        else
          para @commit.id, :size => base_font_size, :margin => 0,
            :stroke => (@selected ? black : gray(0.6))
        
          para @commit.message, :leading => 1, :size => base_font_size,
            :margin => [0,3,0,5]
        
          para @commit.author, :size => base_font_size, :margin => 0,
            :stroke => (@selected ? black : gray(0.3))
        end
      end
    
      if not @selected
        hover { @hover_bg.show }
        leave { @hover_bg.hide }
      end
    
      click do
        app do # undo previous selection
          if formerly_selected = @commits.contents.detect { |ci| ci.selected }
            formerly_selected.selected = false
            formerly_selected.draw_contents
          end
        end
        
        @selected = true
        draw_contents
        
        # self changes in the app block, so..
        commit = @commit
        
        app { view_commit commit }
      end
    end
  end
  
end
