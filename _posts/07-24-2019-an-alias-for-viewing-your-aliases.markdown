# Alias Shrugged

I love Autumn the crisp Fall breeze, bright coloured trees, small talk moves from weather
conditions to pumpkin spice latte bashing... it conjures up memories of buying pencils, binders,
protracters, school agendas, maybe if I was lucky a new backpacks. As a child, the start of every
new school began with me reassuring myself that with the proper tooling I would crush my clases,
become cool and be the highest form of myself. Of course, each year was met with the soul crushing
reality of daydremaing too much in class and using my fancy new mechanical pencil more for
[mawashi](https://en.wikipedia.org/wiki/Pen_spinning) then taking notes. Thankfully, this changed
over time and I eventually pulled up my socks and thankfully by the time I finished my
undergraduate classes I was competitive enough for Graduate Studies.

I think when many people see my [rc files](https://en.wikipedia.org/wiki/Configuration_file) they
view the large amount of aliases as completely pointless and similar to the tools bought by the
inexperienced kid at the start of a new school year. Perhaps they are not wrong, however I also
think that improvements often come from simplifying and streamlining the things we already have.
Grantless for a while I have wanted to write a solution for when people use the comment

>No one can possibly remember all those aliases.
>~Someone looking at my rc file

to shrug off their potential use. It reminds me a bit when people are introduced to vi or emacs and
say nobody can remember all these keystrokes. Consider some `git` aliases from my rc file:

```bash
# Git ]--------------------------------------------------------------------------------------------
alias a='git add'
alias b='git checkout'
alias c='git commit -m'
alias d='git diff'
alias i='git init'
alias f='git fetch --all'
alias l='git log --oneline --graph --all --decorate'
alias m='git checkout master'
alias p='git push'
alias r='git rebase --autosquash -i'
alias s='git status'
alias x='git commit --fixup HEAD'
alias t='cd $(git rev-parse --show-toplevel)'
alias j='t; a .; x; p; cd -'
```

I will grant that some are negiligblly more efficient (I'm looking at you `git init`) but some add
quite a few flags that I really do prefer and make coding a more plesant -- and efficient
experience. Still I agree with them that it is a lot to remember. To combat this I take a page from
`helm`'s book which can help emacs users review user-readable names of functions combined with
their keystrokes easiliy.

# One Alias to Group them All

Let's get stright to the point since I've already waxed poetically about Autumn so far. Imagine you
have a `.bash_profile` that looks like this:

```bash
# Git ]--------------------------------------------------------------------------------------------
alias a='git add'
alias b='git checkout'
alias c='git commit -m'
alias d='git diff'
alias i='git init'
alias f='git fetch --all'
alias l='git log --oneline --graph --all --decorate'
alias m='git checkout master'
alias p='git push'
alias r='git rebase --autosquash -i'
alias s='git status'
alias x='git commit --fixup HEAD'
alias t='cd $(git rev-parse --show-toplevel)'
alias j='t; a .; x; p; cd -'

function del-merged() {
    git for-each-ref --format '%(refname:short)' refs/heads |
    grep -v master                                          |
    xargs git branch -D
}

# Bindings ]---------------------------------------------------------------------------------------
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward
export HISTSIZE=1000000
export HISTFILESIZE=1000000000

# CMD Aliases ]------------------------------------------------------------------------------------
alias grep='grep --color=auto'
alias csv='column -s, -t'
alias cp='cp -iv'
alias mv='mv -iv'
alias ls='ls -h'

function mkcd() {
    mkdir -p "$@" && cd "$@";
}
```

and you want to list all your aliases in the file. Well then just write an alias to do it

```bash
alias alist='list-bash-profile-regex "^alias" | less'

function list-bash-profile-regex() {
    regex=$1
    grep -A 0 -B 1 $regex ~/.bash_profile
}
```

Then when you run it you get launched into a page looking like this

```shellsession
# Git ]--------------------------------------------------------------------------------------------
alias a='git add'
alias b='git checkout'
alias c='git commit -m'
alias d='git diff'
alias i='git init'
alias f='git fetch --all'
alias l='git log --oneline --graph --all --decorate'
alias m='git checkout master'
alias p='git push'
alias r='git rebase --autosquash -i'
alias s='git status'
alias x='git commit --fixup HEAD'
alias t='cd $(git rev-parse --show-toplevel)'
alias j='t; a .; x; p; cd -'
---
# CMD Aliases ]------------------------------------------------------------------------------------
alias alist='list-bash-profile-regex "^alias" | less'
alias grep='grep --color=auto'
alias csv='column -s, -t'
alias cp='cp -iv'
alias mv='mv -iv'
alias ls='ls -h'-
```
Beautiful! Easy! An alias to list your aliases! And futhermore could this really be your dad's old
`grep`? Shouldn't grep just show what the lines that match? We've used the `-B` flag here to add
some additional comment spice to our `less` page. Taking the documentation from `man grep`

```shellsession
...

-B num, --before-context=num
        Print num lines of leading context before each match.
...
```

the `-B 1` flag is how we picked up the comments that I place above each of my blocks of aliases
which are thematically linked. The additional `---`lines indicate a jump to a new block of matched
lines.

# But Wait There's More

We also had functions in our example `bash_profile` so let's write a function to list your
functions

```bash
alias flist="list-funcs"
function list-funcs() {
    # lists all custom functions defined in ~/.bash_profile
    list-bash-profile-regex "^function" |
        grep "^function"                |
        sed "s/^function //"            |
        sed "s/() {$//"                 |
        less
}
```

Resuing our `grep` function that searches `bash_profile` we look for anything line that begins with
`function`, unfortunately we get the additional lines from the `-B` flag as well so we need to pipe
the output to the same regex again. I prefer this solution as it DRYs the location of our
`bash_profile` (even though that would likely never change) at the cost of writing the regex twice
locally close togehter. Besides, I suppose it wouldn't be an rc file if it wasn't a little hacky.
From there we use the stream editor unix tool to chop off the function defintiions and everything
after the brace. Pipe the output to a man page and we get the following

```shellsession
mkcd
function del-merged
list-bash-profile-regex
```
# Summary

If you have shyed away from aliases in the past because you thought managing them was not worth the
additional overhead of complexity give the `alist` alias here a try. It can serve as a useful
cheatsheet to start building the muscle memory required to use them.
