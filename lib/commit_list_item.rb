require "lib/colors"

class CommitListItem < Shoes::Widget
  include Colors
    
  def initialize(commit, default_bg_color, options = {})
    @commit = commit
    
    stack do
      background default_bg_color
      @hover_bg = background(green).hide
      
      # size = 36
      # stack :width => size, :margin => [0,0,3,0] do
      #   image "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(commit.author.email.downcase)}&s=#{size}",
      #     :width => size, :height => size
      # end
      
      stack :margin => (@commit.merge? ? 2 : 5) do # :width => -size+4,
        if @commit.merge?
          para @commit.message, :leading => 1, :size => base_font_size-2,
            :margin => [0,2,0,4], :weight => "bold"
        else
          para @commit.id, :size => base_font_size, :margin => 0, :stroke => gray(0.6)
          
          para @commit.message, :leading => 1, :size => base_font_size,
            :margin => [0,3,0,5]
          
          para @commit.author, :size => base_font_size, :margin => 0, :stroke => gray(0.3)
        end
      end
      
      hover { @hover_bg.show }
      leave { @hover_bg.hide }
      
      click do
        # self changes in the app block, so..
        commit_item, commit = self, @commit
        # might just want to change this stuff so the item doesn't know about the app
        app do
          @selected_commit = commit_item
          view_commit commit
        end
      end
    end
  end
end
