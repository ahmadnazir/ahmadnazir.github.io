---
title: Chaining background processes in the shell
comments: true
tags: linux, shell
---

# Scenario

Suppose you have the following operations:

```
a
b
c
```

You can chain them using the `&&` operator so that they execute in a sequential manner:

```
a && b && c
```

In layman terms, this means is:

- run a
- if a completes, run b
- if b completes, run c

# Problem

What if `b` takes a really long time to execute and you don't want to wait until it finishes execution?

So, what you want is:

- run a
- if a successfully completes, run b
- if b successfully ***starts***, run c

We don't care if `b` executes successfully. All we care about is that `b` is successfully invoked.

# Solution

It is possible to use subshells to make the long running processes run in the background and chain the operations. It would look something like:

```
a && (b &) && c
```

# Example

Let's define our operations so that can actually be called:

```
a() {
  echo 1
}

b() {
  echo 2
}

c() {
  echo 3
}
```

If we chain them, we get the following output:

```
a && b && c
1
2
3
```

Let's say that the middle operation takes too long to complete. Hence redefining `b`:

```
b() {
  sleep 5
  echo 2
}
```

Calling the chained operations again, we see a 5 second delay after `a` is executed:

```
a && b && c
1
< .. 5 second delay .. >
2
3
```

Using subshells, the `b` can be sent to the background and chained as follows:

```
a && (b &) && c
1
3
2
```

Of course, the order of execution is affected as you can see that 3 appears before 2.

If any command fails in the chain, the execution stops there.

# When do I use this?

I use this mostly during initialization of various setups. I don't always want
to wait for all the commands to successfully complete before running the next
command. It is a quick way to run processes in parallel while ensuring that the
chain stops executing if invocation fails for any command.
