= nitgit

nitgit is a Git history browser. It was inspired by Gitnub. I started nitgit mainly 
because there was one thing I thought was missing from these types of tools: the ability 
to de-emphasize or hide merge commits.

I've talked to many people who use git rebase as a way to avoid seeing these commits 
in their history. They do this despite warnings about how rebase can complicate 
or damage your history because tools like Gitnub and `git log` do not provide 
better ways to handle presentation of these merge events. In addition to being 
potentially harmful, rebasing in this manner strikes me as simply an unecessary 
added complexity. I like the notion of push, pull, period. All repos are created equal, 
and all that.

Initially I set out to extend Gitnub, but I found learning the fundamentals of 
XCode's interface builder and RubyCocoa more difficult than I'd hoped. Shoes to the 
rescue!

= LICENSE

WTFPL. See the LICENSE file.

= CONTRIBUTORS

* Seth Thomas Rasmussen <sethrasmussen@gmail.com>
