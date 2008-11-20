Shoes.setup do
  source "gems.github.com"
  gem "mojombo-grit"
end

%w(
digest/md5
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
  
  stack :height => 36 do
    background black
    
    @menu = flow :margin => [7,7,7,0] do
      para "nitgit", :font => "Century Gothic", :size => 16, :stroke => white, :margin => 0
    
      button "open repo", :margin => 0, :displace_top => -4 do
        open_repo ask_open_folder
      end
    
      @name = para "", :font => "Century Gothic", :stroke => blue, :margin => [0,4,6,0]
    
      @branches = list_box :margin => 0, :displace_top => -1 do |b| # [0,3,0,0] do |b|
        @selected_branch = b.text
        load_repo
      end
    
      @pagination = flow :width => 200, :right => 5, :margin => 0, &method(:pagination_browse)
    end
  end
  
  @commits = stack :width => COMMITS_WIDTH
  @diffs   = stack :width => -COMMITS_WIDTH-gutter
  
  # open ourself while developing. sassy!
  # open_repo File.expand_path(File.dirname(__FILE__))
  
  open_repo ask_open_folder
end
