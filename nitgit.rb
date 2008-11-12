Shoes.setup do
  source "gems.github.com"
  gem "mojombo-grit"
end

require "grit"

APP_WIDTH     = 900
COMMITS_WIDTH = 300
DIFFS_WIDTH   = APP_WIDTH - COMMITS_WIDTH

# TODO figure out how to override default styles
BASE_FONT_SIZE = 9

Shoes.app :title => "nitgrit - grit commit browser", :width => APP_WIDTH do
  background "#c3d9ff"
  
  ###
  
  def view_commit(commit)
    @diffs.clear { view_diffs commit }
  end
  
  def view_diffs(commit)
    commit.diffs.each do |d|
      stack :margin => [0,0,0,10] do
        border black
        
        d.diff.split("\n").each do |l|
          stack :padding => 1, :background => background_for_line(l) do
            para l, :size => BASE_FONT_SIZE, :margin => 0, :family => "Courier"
          end
        end
      end
    end
  end
  
  ###
  
  def open_repo(directory)
    @repo = Grit::Repo.new(directory)
    load_repo
  end
  
  def load_repo(page = 1)
    @diffs.clear
    
    @commits.clear do
      @repo.commits.each_with_index do |commit,i|
        stack :padding => 5, :background => (i%2==0 ? gray(0.9) : white) do
          info_style = { :size => BASE_FONT_SIZE, :margin => 0 }
          para commit.id,      info_style
          para commit.message, info_style
          para commit.author,  info_style

          click { view_commit commit }
        end
      end
    end
  end
  
  def background_for_line(line)
    case (line[0] and line[0].chr)
    when "+" then "#97cb81"
    when "-" then "#e87770"
    else gray(0.9)
    end
  end
  
  ###
  
  def stack(options = {}, &block)
    if padding = options.delete(:padding)
      super options do
        background options[:background]
        super options.merge(:margin => padding), &block
      end
    else
      super
    end
  end
  
  ###
  
  @menu = flow do
    background black
    stroke white
    
    button "open repo" do
      open_repo ask_open_folder
    end
  end
  
  @commits = stack :width => COMMITS_WIDTH
  @diffs   = stack :width => 1.0, :margin_left => COMMITS_WIDTH
end
