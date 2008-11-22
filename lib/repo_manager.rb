module RepoManager
  def commits_per_page
    20
  end
  
  def base_font_size
    9
  end
  
  ###
  
  def view_commit(commit)
    # @spinner.show
    slot.scroll_top = 0
    @diffs.clear { view_diffs commit }
    # @spinner.hide
  end
  
  def view_diffs(commit)
    commit.diffs.each do |d|
      stack :margin => [0,0,0,10] do
        d.diff.split("\n").each do |l|
          present_line l
        end
      end
    end
  rescue Grit::Git::GitTimeout
    stack do
      background red
      stack :margin => 5 do
        para "Whoa, timed out! You probably have a ", strong("HUMONGO"), " file in this commit."
        para "We'll try to handle this better in the future. Sorry. :("
      end
    end
  end
  
  def present_line(line)
    style = { :size => base_font_size, :margin => 0, :family => "Courier" }
    
    if line =~ /^(\-|\+){3}/
      style.merge! :weight => "bold", :stroke => white
    end
    
    stack :padding => 1, :background => background_for_line(line) do
      para Iconv.conv("UTF-8", "LATIN1", line), style
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
        bg = if merge? commit
          "#E8F8BD"
        else
          i%2==0 ? gray(0.9) : white
        end
        
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
    # size = 36
    # stack :width => size, :margin => [0,0,3,0] do
    #   image "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(commit.author.email.downcase)}&s=#{size}",
    #     :width => size, :height => size
    # end
    merge = merge?(commit)
    stack :margin => (merge ? 2 : 5) do # :width => -size+4,
      if merge
        para commit.message, :leading => 1, :size => base_font_size-2,
          :margin => [0,2,0,4], :weight => "bold"
      else
        para commit.id, :size => base_font_size, :margin => 0, :stroke => gray(0.6)
        
        para commit.message, :leading => 1, :size => base_font_size,
          :margin => [0,3,0,5]
        
        para commit.author, :size => base_font_size, :margin => 0, :stroke => gray(0.3)
      end
    end
  end
  
  def commits_for_page(page = @page)
    commits = @repo.commits(@selected_branch, commits_per_page, ((page - 1) * commits_per_page))
    commits.reject! { |c| merge? c } if @hide_merges.checked?
    commits
  end
  
  def merge?(commit)
    commit.parents.size > 1
  end
  
  def background_for_line(line)
    case line
    when /^(\-|\+){3}/ then gray(0.3)
    when /^\+{1}/      then green
    when /^\-{1}/      then red
    else white
    end
  end
end
