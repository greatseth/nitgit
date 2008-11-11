Shoes.setup do
  source "gems.github.com"
  gem "mojombo-grit"
end

require "grit"
require "activesupport"

APP_WIDTH = 900
COMMITS_WIDTH = 300

Shoes.app :title => "nitgrit - grit commit browser", :width => APP_WIDTH do
  @repo = Grit::Repo.new File.expand_path("~/diversion/sling/git/SlingIt")
  
  ###
  
  @commits = stack :width => COMMITS_WIDTH do
    @repo.commits.each_with_index do |c,i|
      stack do
        background i%2==0 ? gray(0.9) : white
        
        with_options :size => 9, :margin => 0 do |info|
          info.para c.id
          info.para c.message
          info.para c.author
        end
        
        click do
          @diff.clear do
            c.diffs.each do |d|
              stack :margin => [0,0,0,10] do
                border black
                
                d.diff.split("\n").each do |l|
                  next unless l[0]
                  stack do
                    
                    case l[0].chr
                    when "+" then background("#0f0")
                    when "-" then background(red)
                    else background(gray(0.9))
                    end
                    
                    para l, :size => 9, :margin => 0
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
  @diff = stack :width => APP_WIDTH-COMMITS_WIDTH do
    
  end
end
