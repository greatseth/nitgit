Shoes.setup do
  source "http://gems.github.com"
  gem "mojombo-grit"
end

%w(
grit
iconv
).each { |lib| require lib }

%w(
grit_extensions
settings
colors
repo_manager
pagination
).each { |support| require "lib/#{support}" }

# spinner 
%w(
commit_list_item
labeled_check
).each { |widget| require "lib/#{widget}"}

APP_WIDTH     = 900
COMMITS_WIDTH = 280

###

Shoes.app :title => "nitgit - git commit browser", :width => APP_WIDTH do
  extend Settings, Colors, RepoManager, Pagination
  
  background blue
  
  stack :height => 36 do
    background black
    
    @menu = flow :margin => [7,7,7,0] do
      para "nitgit", :font => "Century Gothic", :size => 16, :stroke => white, :margin => 0
    
      button "open repo", :margin => 0, :displace_top => -4 do
        open_repo ask_open_folder
      end
    
      @name = para "", :font => "Century Gothic", :stroke => blue, :margin => [0,4,6,0]
    
      @branches = list_box :margin => [0,3,0,0], :displace_top => -4 do |b|
        @selected_branch = b.text
        load_repo
      end
      
      @hide_merges = labeled_check("hide merges",
        :width => 100, :stroke => white, :size => base_font_size,
        :checked => repo_settings[:hide_merges]) do
          repo_settings[:hide_merges] = @hide_merges.checked?
          save_settings!
          load_repo @page
      end
      
      @pagination = flow :width => 200, :right => 5, :margin => 0, &method(:pagination_browse)
      
      # @spinner = spinner
    end
  end
  
  @commits = stack :width => COMMITS_WIDTH
  @diffs   = stack :width => -COMMITS_WIDTH-gutter
  
  open_repo ask_open_folder
end
