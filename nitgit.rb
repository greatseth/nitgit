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

COMMITS_PER_PAGE = 20

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
    @page_display.text = @page = page
    
    @diffs.clear
    
    @commits_list = {}
    
    @commits.clear do
      commits_for_page.each_with_index do |commit,i|
        bg = i%2==0 ? gray(0.9) : white
        @commits_list[i] = stack { commit_list_item commit, bg }
        
        @commits_list[i].click { view_commit commit }
        @commits_list[i].hover { @commits_list[i].clear { commit_list_item commit, green } }
        @commits_list[i].leave { @commits_list[i].clear { commit_list_item commit, bg } }
      end
    end
    
    @prev.state = ("disabled" if page == 1) 
    @next.state = ("disabled" if commits_for_page(@page + 1).empty?)
  end
  
  def commit_list_item(commit, bg)
    background bg
    merge = commit.parents.size > 1
    stack :margin => (merge ? 2 : 5) do
      para commit.id, :size => BASE_FONT_SIZE, :margin => 0, :stroke => gray(0.6) unless merge
      
      if merge
        para commit.message, :size => BASE_FONT_SIZE-2, :margin => [0,2,0,4], :leading => 1, :weight => "bold"
      else
        para commit.message, :size => BASE_FONT_SIZE, :margin => [0,5,0,7], :leading => 1
      end
      
      para commit.author, :size => BASE_FONT_SIZE, :margin => 0, :stroke => gray(0.3) unless merge
    end
  end
  
  def commits_for_page(page = @page)
    @repo.commits(@selected_branch, COMMITS_PER_PAGE, ((page - 1) * COMMITS_PER_PAGE))
  end
  
  HEADING_LINE = /^(\-|\+){3}/
  ADDED_LINE   = /^\+{1}/
  REMOVED_LINE = /^\-{1}/
  
  def background_for_line(line)
    case line
    when HEADING_LINE then gray(0.3)
    when ADDED_LINE   then green
    when REMOVED_LINE then red
    else white
    end
  end
  
  ###
  
  @menu = flow :padding => [5,5,5,0], :background => black do
    para "nitgit", :font => "Century Gothic", :size => 16, :stroke => white
    
    button "open repo" do
      open_repo ask_open_folder
    end
    
    @name = para "", :font => "Century Gothic", :stroke => blue,
      :margin_top => 7, :margin_right => 8
    
    @branches = list_box :margin_top => 3 do |b|
      @selected_branch = b.text
      load_repo
    end
    
    @pagination = flow :width => 200, :top => 5, :right => 5 do
      @prev = button "< prev" do
        load_repo page
      end
      @page_display = para @page, :stroke => green
      @next = button "next >" do
        load_repo(@page + 1)
      end
    end
  end
  
  @commits = stack :width => COMMITS_WIDTH
  @diffs   = stack :width => -COMMITS_WIDTH-gutter
  
  # open ourself while developing. sassy!
  open_repo File.expand_path(File.dirname(__FILE__))
end
