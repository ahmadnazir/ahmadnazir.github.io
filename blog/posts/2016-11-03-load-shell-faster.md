---
title: Load the shell faster
---

**tldr:** The shell can be started faster by replacing the time consumming
scripts with [shims](https://en.wikipedia.org/wiki/Shim_(computing)) which can
lazy-load the functionality for those scripts

<br />

## Problem

Lately, zsh is taking way too long to boot-up for me i.e. around .3 secs.. long
enough to annoy me. I normally reach for `Ctrl-R` to search the command history as soon as the shell starts and if the shell takes too long to start-up the control character gets lost.. forcing me to press that combination of keys again. Clearly, I can't be expected to live with this atrocity and something needs to be done.

Here is some timing info for my shell:

```
mandark@mandark ~$ time zsh -i -c exit
zsh -i -c exit  0.32s user 0.11s system 101% cpu 0.427 total
```

<br />

## Culprit

After timing some of the suspects in my `.zshrc` file, I found out that loading
`autojump` and calling `compinit` was delaying the initial boot time by about .2
secs.


Here are the calls in the `.zshrc` file that take the most time:

```
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] \
  && source $HOME/.autojump/etc/profile.d/autojump.sh;
autoload -U compinit && compinit -u;
```

Here is the timing info over 25 runs of the initialization including calls to
`autojump` and `compinit`:

```
mandark@mandark ~$ time-n-cmd 25 'zsh -i -c exit' 2>&1 > /dev/null
  7.92s user 2.33s system 101% cpu 10.118 total
```

and without loading `autojump` and `compinit`:

```
mandark@mandark ~$ time-n-cmd 25 'zsh -i -c exit' 2>&1 > /dev/null
  1.95s user 0.88s system 101% cpu 2.799 total
```

That is **75% of the total initialization time**.

<br />

## Solution


### Background processes?

My first attempt as to wrap the time-consuming calls in a function and call that
function by putting it in the background. That helps with the start-up times for
sure but the variables and commands are not sourced to the shell calling that
function .. hence this is useless. Here is what I had in mind.

```
function init ()
{
  [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] \
    && source $HOME/.autojump/etc/profile.d/autojump.sh \ # sourcing inside a function
    && autoload -U compinit && compinit -u \
    && echo "\n\ninit :: Autojump and comp init are loaded !"
}
init &
```

I would like to understand why `source` behaves differently when called inside a function .. but I'll leave that for another day.


### Lazy Load the functions!

After googling a bit, I realized that other people have been solving this using shims that lazy-load the functionality. In my case, I created a shim for the `autojump` function `j`:

```
j() {
    unset -f j
    [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] \
        && source $HOME/.autojump/etc/profile.d/autojump.sh \
        && autoload -U compinit && compinit -u
    j "$@"
}
```

This loads the functionality for autoloading when it is requested and not at shell start-up. Pretty neat!

Here is the new timing information:

```
mandark@mandark ~$ time-n-cmd 25 'zsh -i -c exit' 2>&1 > /dev/null
  2.07s user 0.91s system 101% cpu 2.946 total
```

That is almost a **4 times performance increase!**

<br />

## Appendix

Timing a command multiple times:

```
# Usage: time-n-cmd TIMES CMD
#
time-n-cmd() {

  # params
  #
  local times=$1
  local command=$2

  # Time the command by running mutiple times
  #
  time (
  for run in {1..$times}
  do
    sh -c $command 2>&1 > /dev/null
  done
  )

}
```

<br />
<br />
<div id="disqus_thread"></div>
<script>
    /**
     *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
     *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables
     */
    /*
    var disqus_config = function () {
        this.page.url = PAGE_URL;  // Replace PAGE_URL with your page's canonical URL variable
        this.page.identifier = PAGE_IDENTIFIER; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
    };
    */
    (function() {  // DON'T EDIT BELOW THIS LINE
        var d = document, s = d.createElement('script');
        
        s.src = '//ahmadnazir.disqus.com/embed.js';
        
        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
    })();
</script>

<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
