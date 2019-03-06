## Title

Yet another DSL for querying relational databases

## Abstract

Writing your own DSLs is more convenient than ever. This talk is about `pine` - an experimental DSL written in Clojure - for querying databases. It makes querying easier by letting the user focus on *what* is needed instead of *how* the underlying data is related.

## Description

Writing SQL queries can be somewhat inconvenient - I know it might not be obvious but just hear me out ...

When writing an SQL statement, you have to think of the following two things:
- *what* is the question , and
- *how* is the data related

For Example, if I want to ask: 

```
For customer with ID 1, give me all the users with name "John"
```

I would have to write something like this:

```
SELECT u.
  FROM customers AS c
  JOIN users AS u
    ON (u.customerId = c.id)
 WHERE c.id = 1
   AND u.name LIKE "John*"
```

The *what* and the *how* is all mixed up.

Ideally, I want to delegate the *how* to the DSL and write something like this:

```
customers 1 | users name=John
```

This solves the following problems for me:

- **Hides the plumbing:** I shouldn't have to know how the underlying data is related
- **Incremental calculations:** I should be able to incrementally ask questions instead of changing the original query e.g. if I also want the `addresses` for the users, I should be able to build on the previous query instead of modifying it:
```
customers 1 | users name=John | addresses
```
- **Expressive:** It is easier to read because it shows the essence of the question without the noise


Being able to express the query in the form shown above can really help focus
on *what* is need instead of *how* is the data extracted. My experience of
writing a DSL not only solved a real problem for me but it was quite a lot of
fun.




## Pitch

I have been working at a startup for the last few years and customer support is
one of those things that is implicitly included in the job description. With the
growth of incoming support, it was becoming important to conveniently query the
database. There were times when I had to write sql queries on the fly, while the
customers were on the line. I built `pine` to make the process of asking
questions from the database convenient. `pine` is still experimential but it
solved a real problem for me. I want to talk about `pine` and show that writing
DSLs in clojure is fairly simple.

Pine : https://github.com/ahmadnazir/pine

I have talked about it at the local Clojure meetup in Copenhagen: http://bit.ly/2IGbl7S

Interestingly, I tried to implement this in Haskell to begin with but I realized that Clojure was the better tool to solve this specific problem. I wrote about it here: https://ahmadnazir.github.io/posts/2017-11-16-2-pine/post.html

## Bio

I have been working as a senior software engineer at Penneo for the last 4
years, building the digital signature platform for Scandinavian markets (and
beyond). Before that, I was responsible for the Vulnerability Intelligence
Database at Secunia, a software security company acquired by Flexera Software.

Erasmus Mundus Alumni, MS from KTH Sweden, DTU Denmark.

Blog : https://ahmadnazir.github.io/
Github : https://github.com/ahmadnazir
Twitter : https://twitter.com/ahmadnazir
Linkedin : https://www.linkedin.com/in/ahmadnazirraja
