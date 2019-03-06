## Title

Yet another DSL for talking to databases

## Abstract

How would you feel if you are being micromanaged? No freedom of thought or control over decisions, just do what you're told! You would feel like a machine - and who feels like that all the time? well, machines, of course! We constantly micromanage them by telling them *how* instead of *what* to do. This affects our ability to focus on what really matters.

Writing SQL is also an example where we are working on a lower level of abstraction. `pine` is an experimental DSL written in Clojure that solves this problem and servers as a natural interface when talking to databases.

## Details

*Include any pertinent details such as outlines, outcomes or intended audience.*

### pine - an experimenal DSL

`pine` a DSL that takes inspiration from the unix command line. Imagine if you could query your database using pipes e.g. If you want all users for customer with ID 1, this is what you would write:

```
customers 1 | users
```

If you want the addresses as well:

```
customers 1 | users | address
```

Well, with `pine` you can do that and it is written in clojure!


### Outline

This talk is broken in to the following 2 parts

####  1. Thinking declaratively (building a case for pine)

This is where I want to show why is there a need for a tool like pine. I would like to go through a few examples where we tend to think imperatively instead of declaratively.

I want to share why I feel that writing SQLs is inconvenient and what is needed to solve the problem.

#### 2. Building pine

I want to talk about my experience of building `pine`. My first attempt was building the language in Haskell but I failed miserably. Clojure was the right tool for the job and it was a lot of fun.

I would also like to highlight some core design principles for the language.

## Pitch
*Tell us why people must see this talk. How will the audience benefit, what will they learn? It's not about you, it's about them!*

We, the software people, are guilty of micromanagement. We micromanage our machines all the time. This is probably needed in some cases but there are times where we should rely on the machine's ability to figure out *how* to do the job. Telling our machines *what* to do instead of *how*, requires a fundamental mind shift - something that is already happening in the programming community. The rise of functional programming is a clear example. However, we can use the benefits of thinking in a declarative manner in other areas and it can improve our focus.

I want to share some examples where we are still thinking on a lower level and we can improve our focus by thinking in a declarative manner. I have realized that writing SQLs can be made more convenient if we use a different syntax and let the machine do the hardwork. `pine` is an experimental DSL that solves part of the problem.

## Bio

I have been working at a startup (Backend developer, Penneo) for the last few years and customer support is one of those things that is implicitly included in the job description. With the growth of incoming support, I started realizing that writing SQL statements is unnecessarily inconvenient. I built `pine` to solve that problem. It is still experimential but it solved a real problem for me.
