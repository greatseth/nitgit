# nitgit

nitgit is a Git history browser. It was inspired by Gitnub. I started nitgit mainly 
because there was one thing I thought was missing from these types of tools: the ability 
to de-emphasize or hide merge commits.

I've talked to many people who use `git rebase` in some form or another as a way to 
avoid seeing these commits in their history. In addition to being 
potentially harmful, rebasing in this manner strikes me as simply an unecessary 
added complexity and a hacky workaround for insufficient tools. I like the notion of 
push, pull, period. All repos are created equal, and all that.

Here is a word of warning about `git rebase` from 
https://we.riseup.net/debian/git-development-howto

> But wait, don’t get trigger happy with ‘git rebase’. You should repeat after
> me, “never use git rebase on repositories with more than one user, or
> repositories that I have published to the world”. Why? Well, the “git rebase”
> manpage says why, “When you rebase a branch, you are changing its history in a
> way that will cause problems for anyone who already has a copy of the branch in
> their repository and tries to pull updates from you.” So “git rebase” should
> only, and I mean only, be used in situations where you maintain a private branch
> of a project, you never share it in any way, (except to submit patches to
> upstream). If you are working with a team on maintaining a branch, or want to
> post this branch online for others to pull, you do not want to use git-rebase!
> 
> So you should only use git rebase when you are working on your private rails2.0
> migration branch that you want to keep up-to-date with your ‘master’ branch
> changes, as long as you aren’t publishing this rails2.0 branch. When you are
> ready to publish that branch, you would merge it into your master branch, and
> then publish that.

The `git rebase` man page also has some word of warning around the same idea.

Initially I set out to extend Gitnub, but I found learning the fundamentals of 
XCode's interface builder and RubyCocoa more difficult than I'd hoped. Shoes to the 
rescue!

## LICENSE

WTFPL. See the LICENSE file.

## CONTRIBUTORS

* Seth Thomas Rasmussen <sethrasmussen@gmail.com>
