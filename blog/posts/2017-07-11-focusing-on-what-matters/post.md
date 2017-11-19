---
title: Focusing on *what* matters
comments: true
---

**tldr:** I got into a discussion at work about "What makes a software developer
good?", and even though it seems like a simple question, we couldn't really
answer it convincingly. I'll just use this post to ramble on my thoughts about
the matter.

## Software developers are problems solvers
In order to answer what makes software developers good at what they do, we have
to answer what is it that software developers do. Software developers are
basically problems solvers and we rely on software as our main instrument. To become
efficient, we will have to analyze the process of problem solving.

## Process of problem solving dissected!

**Disclaimer:** I like to simplify things, even sometimes oversimplify them. The
model might be wrong but it gives me a reference point, so bear with me while I
ramble on :)

When we attempt to solve any problem, we first try to **gather information** about
that problem and once we think that we have enough, we start tackling the
problem. Usually, we try to **break the problem down into smaller problems** and
keep doing that until we reach a point where the solution of the smaller problem
is simple enough. Once all the smaller problems are solved, we **combined the
solutions** and the bigger problem is solved. (Yeah, divide and conquer!)

At any time, our brain is either gathering information or breaking down the
problem. We keep going back and forth and this is what I believe are the two
activities that our brain is involved in.

I feel this is a natural way of problem solving and you can apply that same
principle on an organizational level. Here is an example of a hypothetical
company that wants to dominate the world by helping people sign their documents
digitally and securely, let's call it .. mmm .. **Penneo**. Let's say the
board of directors decide that the company has to provide solutions in the Nordic
region. This is how the interactions are going to take place:

- **Board -> CEO :** We want Penneo to be present in the Nordic countries

The CEO thinks about how to do this, breaks it into smaller tasks that can be delegated. One of the tasks that he delegates is:

- **CEO -> CTO :** Build me an integration with Sweden

The CTO thinks about this and splits it further.

- **CTO -> Back-end Team  :** Build a service that enables Swedish customers to login and sign
- **CTO -> Front-end Team :** Build a new shiny login page

Something that is quite interesting about the tasks being delegated is that all
of them are about **what** was it that is need, and **how** to achieve that
objective is not relevant. This is what makes it possible for anyone to break it
down according to how they see it best. Once a problem is broken down to a point
where we need to think about **how** to do it, we lose the ability to further
split it down or further delegate it. Also, if someone does try to
delegate something in terms of *how* and not *what*, you would call that
*micro-management*, and that isn't always effective.

## Curse of knowing

Breaking down problems into smaller **what** problems seems to be a natural way
to solving the overall problem. It seems like this is how we can work together
efficiently, and it seems that this is how we should be working on an individual
level as well. However, it is not always that easy to keep focusing on the
*what* instead of the *how*. Imagine that the task is "show a list of items in a
table", I tend to start thinking about "do I know of a library that would let me
do it in *react*.. or *elm* ..". Immediately, I focus on the the *how* whereas I
should be thinking of the *what* i.e. What is the type of data that the table
contains, what is the use case etc. This is the **curse of knowing** i.e. just
because I have experience in a few tools, I start thinking of the
implementation. Whenever something like this happens, the brain shifts from the
**what domain** to the **how domain** and this comes at a cost. If the brain
stays in the *how domain* for too long, the cost becomes significant.

## but then how do I actually *do* something?

Of course, you can't always keep thinking in terms of *what*. At some point, you
have the execute and that is when you need to know *how* to do it.

My point is that the *how* problems should be so simple that they shouldn't move
your focus away from the main objective. If you spend too much time in the **how
domain**, you can get distracted. There are some things that you can be done to
minimize such context switches:

### 1. Internalize the operation

Do the task so many times that it becomes part of the muscle memory. Imagine
this: when you speak something, you brain doesn't actively think about moving
the tongue to produce sound. Similarly, when you walk, you don't actively think
about moving your legs, it just happens, while your brain thinks about other
things.
  
As software developers, there are certain operations that we shouldn't have to
think about while working e.g. searching for things (files with a name that
matches a pattern, or specific text in files), using version control (checking
out a branch, rebasing your commits on top of something else etc), etc.

### 2. Automate the monotonous tasks

However, there are certain tasks that despite being simple, they take enough
time to cause a context switch for the brain. Every single time that happens, we
lose focus from the main objective and that affects our productivity. Automating
such tasks can help us stay in the *what domain* and maintain focus.

These tasks are usually very specific to individuals or teams (solutions for the
generic tasks are often available, specially in the open source community). As
an example, at Penneo, we have a lot of micro services, and setting up every
service can be slightly different from the other. I started working on a tool
named [aww yeah][aww-yeah] that gives me and my team a consistent interface when
developing features for these services. A simple example is viewing logs for the
services. Each service can have different types of logs in different locations.
Using a consistent interface, the developers don't have to find the logs,
instead give a command such as:

```
aww monitor auth
```

The `aww` tool knows where the logs are for the authentication service and
starts showing them as they come.

### 3. Shift the burden of domain knowledge to tools

It usually happens that there is one guy in the team that other developers seek
help from when setting things up and getting up to speed. This reliance on
people is not always needed. I am not saying that team members shouldn't talk,
all I am saying is that this dependency on some key people can be avoided;
either by creating good documentation, or better yet by building tools that help
developers do what they are trying to do.

In my experience, I have seen people somewhat ignoring the README files just
because it is time consuming to read or too boring to go through all that text.
Also, READMEs can sometimes get a bit out of hand describing all the details
that might not have any immediate relevance. A better way would be to **create
tools that let you perform the tasks and that also ask relevant questions when
needed**. Building helper tools like these that have the domain knowledge
requires time and commitment but are totally worth the effort as they keep
the brain free from the unnecessary details.

## Wrapping it up

The key to become effective at problem solving is to **maintain focus on the
main objective and avoid context switches**. The idea is to keep thinking in
terms of **what is it that we want to do, instead of how we do it**.

Internalizing the basic activities comes with time, but we can try to **automate
the mundane tasks** and **build the tools that ask us the relevant questions**
instead of the other way around.

At Penneo, I am working with a fantastic team that is helping me build `aww
yeah` that solves some of these problems for us and I am really excited about
it!

## Acknowledgements

Thanks to [Alejandro Recoveri][aj] for coming up with the name for the tool `aww
yeah`.The idea is that setting up services and working with them should be so
easy that you go *awhawwwnw yeahh!!* :D

[aww-yeah]: https://github.com/ahmadnazir/aww-yeah
[aj]: https://github.com/axltxl
