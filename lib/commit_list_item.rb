require "lib/colors"

class CommitListItem < Shoes::Widget
  include Colors
  
  attr_accessor :selected
  
  def initialize(commit, default_bg_color, options = {})
    @commit   = commit
    @selected = false
    
    @slot = flow
    
    @default_bg_color = default_bg_color
    
    draw_contents
  end
  
  def draw_contents
    @slot.clear do
      if @selected
        background green
      else
        background @default_bg_color
      end
    
      @hover_bg = background(green).hide unless @selected
    
      gravatar_size = 36
      
      stack :width => gravatar_size do
        image "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(@commit.author.email.downcase)}&s=#{gravatar_size}",
          :width => gravatar_size - 3, :height => gravatar_size - 3, :margin => 3
      end
      
      stack :margin => (@commit.merge? ? 2 : 5), :width => -gravatar_size do
        if @commit.merge?
          para @commit.message, :leading => 1, :size => base_font_size-2,
            :margin => [0,2,0,4], :weight => "bold"
        else
          para @commit.id, :size => base_font_size-1, :margin => 0,
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
