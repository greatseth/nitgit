require "lib/colors"

class CommitListItem < Shoes::Widget
  include Colors
  
  attr_accessor :selected
  
  def initialize(commit, default_bg_color)
    @commit   = commit
    @selected = false
    
    @slot = flow
    
    @default_bg_color = default_bg_color
    
    draw_contents
  end
  
  def draw_contents
    @slot.clear do
      @background = if @selected
        background green
      else
        background @default_bg_color
        # @hover_bg = background(green).hide
      end
      
      gravatar_size = 36
      
      stack :width => gravatar_size do
        image @commit.author.gravatar_url(gravatar_size),
          :width => gravatar_size - 3, :height => gravatar_size - 3, :margin => 3
      end
      
      stack :margin => (@commit.merge? ? 2 : 5), :width => -gravatar_size do
        if @commit.merge?
          para @commit.message, :leading => 1, :size => base_font_size-2,
            :margin => [0,2,0,4], :weight => "bold"
        else
          id_link = link @commit.id do
            self.clipboard = @commit.id
          end
          para id_link, :size => base_font_size-1, :margin => 0,
            :stroke => (@selected ? black : gray(0.6))
          
          para @commit.message, :leading => 1, :size => base_font_size,
            :margin => [0,3,0,5]
          
          email_link = @commit.author # link @commit.author, :click => @commit.author.email
          para email_link, :size => base_font_size, :margin => 0,
            :stroke => (@selected ? black : gray(0.3))
        end
      end
    
      if not @selected
        hover { @background.fill = green }
        leave { @background.fill = @default_bg_color }
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
