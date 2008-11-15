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
    
    @commits.clear do
      commits_for_page.each_with_index do |commit,i|
        bg = (i%2==0 ? gray(0.9) : white)
        stack :padding => 5, :background => bg do
          para commit.id,      :size => BASE_FONT_SIZE, :margin => 0, :stroke => gray(0.6)
          para commit.message, :size => BASE_FONT_SIZE, :margin => [0,5,0,5]
          para commit.author,  :size => BASE_FONT_SIZE, :margin => 0, :stroke => gray(0.3)
          
          click { view_commit commit }
          # Think special slots need to be implemented as widgets for these to 
          # work as expected..
          # 
          # hover { background blue }
          # leave { background bg }
        end
      end
    end
    
    @prev.state = ("disabled" if page == 1)
    @next.state = ("disabled" if commits_for_page(@page + 1).empty?)
  end
  
  def commits_for_page(page = @page)
    @repo.commits(@selected_branch, COMMITS_PER_PAGE, ((page - 1) * COMMITS_PER_PAGE))
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
    
    @name = para "", :font => "Century Gothic", :stroke => blue,
      :margin_top => 7, :margin_right => 8
    
    @branches = list_box :margin_top => 3 do |b|
      @selected_branch = b.text
      load_repo
    end
    
    @pagination = flow :width => 150, :top => 5, :right => 5 do
      @prev = button "<" do
        if not (page = @page - 1).zero?
          load_repo page
        end
      end
      @page_display = para @page, :stroke => green
      @next = button ">" do
        # TODO end of paging logic, currently will just advance to blank pages
        load_repo(@page + 1)
      end
    end
  end
  
  @commits = stack :width => COMMITS_WIDTH
  @diffs   = stack :width => -COMMITS_WIDTH-gutter
  
  # open ourself while developing. sassy!
  open_repo Dir.pwd
end
