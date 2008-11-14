Shoes.setup do
  source "gems.github.com"
  gem "mojombo-grit"
end

require "grit"

%w(
colors
slots_with_padding
).each { |x| require "lib/#{x}" }

APP_WIDTH     = 900
COMMITS_WIDTH = 300

# TODO figure out how to override default styles
BASE_FONT_SIZE = 9

Shoes.app :title => "nitgit - grit commit browser", :width => APP_WIDTH do
  extend Colors, SlotsWithPadding
  
  background blue
  
  ###
  
  def view_commit(commit)
    @diffs.clear { view_diffs commit }
  end
  
  def view_diffs(commit)
    commit.diffs.each do |d|
      stack :margin => [0,0,0,10] do
        d.diff.split("\n").each do |l|
          present_line l
        end
      end
    end
  end
  
  def present_line(line)
    style = { :size => BASE_FONT_SIZE, :margin => 0, :family => "Courier" }
    
    if line =~ /^(\-|\+){3}/
      style.merge! :weight => "bold", :stroke => white
    end
    
    stack :padding => 1, :background => background_for_line(line) do
      para line, style
    end
  end
  
  ###
  
  def open_repo(directory)
    @repo = Grit::Repo.new(directory)
    
    @name.text = File.basename directory
    
    @branches.items = @repo.branches.map { |b| b.name }
    @branches.choose "master"
    
    load_repo
  end
  
  def load_repo(page = 1)
    @diffs.clear
    
    @commits.clear do
      @repo.commits(@selected_branch).each_with_index do |commit,i|
        stack :padding => 5, :background => (i%2==0 ? gray(0.9) : white) do
          para commit.id,      :size => BASE_FONT_SIZE, :margin => 0, :stroke => gray(0.6)
          para commit.message, :size => BASE_FONT_SIZE, :margin => [0,5,0,5]
          para commit.author,  :size => BASE_FONT_SIZE, :margin => 0, :stroke => gray(0.3)
          
          click { view_commit commit }
        end
      end
    end
  end
  
  def background_for_line(line)
    case line
    when /^(\-|\+){3}/ then gray(0.3)
    when /^\+{1}/      then green
    when /^\-{1}/       then red
    else white
    end
  end
  
  ###
  
  @menu = flow :padding => [5,5,5,0], :background => black do
    para "nitgit", :font => "Century Gothic", :size => 16, :stroke => white
    
    button "open repo" do
      open_repo ask_open_folder
    end
    
    @name = para "", :stroke => blue, :margin_top => 5
    
    @branches = list_box :margin_top => 3, :margin_left => 5 do |b|
      @selected_branch = b.text
      load_repo
    end
  end
  
  @commits = stack :width => COMMITS_WIDTH
  @diffs   = stack :width => -COMMITS_WIDTH-gutter
  
  # open ourself while developing. sassy!
  open_repo Dir.pwd
end
