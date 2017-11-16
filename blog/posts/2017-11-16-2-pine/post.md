---
title: Build me a DSL for great good [2]
comments: true
---

**tldr:** Some problems are dynamic in nature and tackling them using a
statically typed language might be a struggle. I have been working on a domain
specific language `pine`, that will hopefully let me query data conveniently
than writing `SELECT` statements. I have been struggling to implement it in
Haskell but it seems like there might be a better tool for the job.

## Recap of "Pine" : Building a convenient querying functionality

I was trying to figure out a different way to interactively and conveniently
query a relational dataset. A relational dataset could be:

- **REST API:** where for every resource I am interested in the `GET` method and
based on the result, I should be able to get the related resources.

- **Relational database:** In this case I want a convenient way to write
  `SELECT` statements.

For me, convenience is about staying on the command line (or inside the
editor) - basically using text to search the data with the minimum number of
characters. It turns out that when you have to write a lot of queries, a lazy
person like me will try to find a shorter syntax for `SELECT` statements and
`JOIN`s.

So, if I want to ask the system about all the users for customer 'Acme Inc',
instead of the following:

```
SELECT *
FROM users AS u
JOIN customer AS c
ON (u.customer_id = c.id)
WHERE c.name = 'Acme Inc'
```

I want something like:

```
customers "Acme" | users *
```

Unix Pipes Rules!

A query in the latter form supports my chain of thought and helps me stay in the
*what* domain
i.e.
[I should tell the machine what I want instead of how I want it][focusing-on-what-matters].

## Attempting an implementation in Haskell

I wanted to solve this problem using Haskell because I thought it would help me
learn it - and indeed it turned out to be a valuable learning experience.
However, it didn't feel like the right tool for this job. The nature of the
problem that I am trying to solve is dynamic and I was jumping through hoops to
achieve this in Haskell. I am probably offending a few haskell fans but I would
love to hear from anyone who can show me the light.

### 1. Why choose a statically type language when you need dynamic types?

I want to **explore the domain of my data set** - I don't really know the types
at compile time, or I don't want to be tied with a specific domain. For example,
if I have a MySql database, I could create types corresponding to every table in
the database but then my implementation would be specific for that schema. I
wanted to be able to to feed the program any schema and start exploring the relationships
between the data. In other words, I want to be able to generate types at run
time, which goes against static typing. So... no bueno!

### 2. Working with records is sometimes frustrating

I can't include two records with the same fields in the same module. This is
because the record fields act as functions which would lead to two functions
with the same name in the module. Without enabling any extension, the following
does not work:

```
data Customer = Customer
  { name :: String
  } deriving (Show)
  
data User = User
  { name :: String
  , gender :: String
  } deriving (Show)
```

The record field `name` is used in two places so the compiler will complain
about `name` being unambiguous. You can enable the extension
`DuplicateRecordFields` to overcome this however when you'll get a problem when
using the record fields as selectors e.g. the following will not work:

```
name $ customer
name $ user
```

### 3. How to pattern match on only the arguments of value constructors... wait, what?

Allow me to explain, here is a data type:

```
data Bool = True | False
```

`True` and `False` are functions, also known as `value constructors`. In this
example they don't need any arguments. Here is another example:

```
type String     = Name
type CustomerId = Int

type Customer = (Id, Name)
type User     = (Id, Name, CustomerId)

data Entity
  =
    CustomerEntity (Maybe Customer)
  | UserEntity     (Maybe User)
```

Let's say I want to extract the id of an entity. I don't care what the type of entity it is. So, I want to be able to do this (which won't work):

```
getId :: Entity -> Maybe Id
getId entity = case entity of
     _ (Just r)       -> Just $ sel1 r
     _ Nothing        -> Nothing
```

It is required to specify the value constructor which is either `CustomerEntity`
or `UserEntity`. I can't use a generalized pattern and use `_` in place of the
value constructor. This results in code bloat and you know what happens when
things bloats... well, somebody pukes! Quite possibly, there is a
way to handle this... I can't really figure it out.

## Conclusion

Haskell seems like a really powerful tool but **if the nature of the problem is
data exploration, a dynamic language might be a better fit**. I'll use the
concepts that I have learned and try to solve this problem in another language.
Only because I am familiar with javascript, I am tempted to implement this
in [ramda][ramda] (library that supports programming using the functional
style). Let's see how that goes!

[focusing-on-what-matters]: https://ahmadnazir.github.io/posts/2017-07-11-focusing-on-what-matters/post.html
[ramda]: http://ramdajs.com/
