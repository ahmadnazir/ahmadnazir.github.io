---
title: Load the shell faster
---

**tldr:** The shell can be started faster by running time-consuming scripts in
the background

<br />

## Problem

Lately, zsh is taking way too long to boot up for me i.e. around .3 secs.. long
enough for me to miss the first few key strokes when I spin up a new shell.

Here is some timing info:

```
mandark@mandark ~$ time zsh -i -c exit
zsh -i -c exit  0.32s user 0.11s system 101% cpu 0.427 total
```

<br />

## Culprit

After timing some of the suspects in my `.zshrc` file, I found out that loading
`autojump.sh` and calling `compinit` was delaying the initial boot time by about
.2 secs.


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

## Solution .. or more like a hack!

Wrap the calls that are taking the most time into a function and call the
function by running it in the background:

```
function init() {
  # @prereq: https://github.com/wting/autojump
  [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] \
	  && source $HOME/.autojump/etc/profile.d/autojump.sh \
	  && autoload -U compinit && compinit -u \
	  && echo "\n\ninit :: Autojump and comp init are loaded !"
}

init &
```

Here is the new timing information:

```
mandark@mandark ~$ time-n-cmd 25 'zsh -i -c exit' 2>&1 > /dev/null
..
  2.03s user 0.94s system 101% cpu 2.935 total
```

That is almost a **4 times performance increase!**

However, I have an annoying message about the background processes that I can't
get rid of. This is how it looks now at start-up:

```
[1] 17414
mandark@mandark ~$                                                                                                 

init :: Autojump and comp init are loaded !

[1]  + 17414 done       init
mandark@mandark ~$ 
```

.. but it's good enough for me!

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
