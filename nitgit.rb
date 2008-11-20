Shoes.setup do
  source "gems.github.com"
  gem "mojombo-grit"
end

%w(
grit
iconv
).each { |x| require x }

%w(
colors
slots_with_padding
repo_manager
pagination
).each { |x| require "lib/#{x}" }

APP_WIDTH     = 900
COMMITS_WIDTH = 280

Shoes.app :title => "nitgit - grit commit browser", :width => APP_WIDTH do
  extend Colors, SlotsWithPadding, RepoManager, Pagination
  
  background blue
  
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
    
    @pagination = flow :width => 200, :right => 5, &method(:pagination_browse)
  end
  
  @commits = stack :width => COMMITS_WIDTH
  @diffs   = stack :width => -COMMITS_WIDTH-gutter
  
  # open ourself while developing. sassy!
  open_repo File.expand_path(File.dirname(__FILE__))
end
