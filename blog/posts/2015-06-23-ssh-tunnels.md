---
title:  Accessing remote services using SSH Tunnels
---

Lately I have been using emacs **[SQLi][sqli]** mode to interact with the. Most
of the times I can't access the database directly from my machine - I
have to ssh into an intermediate server that has access to the
database server. This strategy doesn't always work if the intermediate
server doesn't have an sql client installed
(e.g. `mysql-client`). What I really want is to make the database
appear as if it were running locally. SSH tunnels solves this problem
for me:

Let's say you have the following servers running:

- `app.com`
- `db.com` (only accessible via `app.com`)

Here is how the database on `db.com` can be accessed locally:

```
ssh app.com -L 5000:db.com:3306 -N
```

We are instructing the ssh utility to create a tunnel that can
redirect your traffic to `db.com` via `app.com`:

- Forward all traffic coming on `localhost:5000` to `app.com`
- All traffic terminating on `app.com` within the tunnel is redirected
  to `db.com:3306`

Now you can try:

```
mysql --host 127.0.0.1 --port 5000
```

**Note:** Use `127.0.0.1` to create a network socket and not
  `localhost` which will use a unix socket instead.

Gven that you have ssh access, you can **control the traffic on a
remote server** with a simple command and **use locally installed
utilities to use services available on remote machines**. The syntax
is not so intuitive at first, but once you get a hang of it, this is
really powerful!

[sqli]: https://www.emacswiki.org/emacs/SqlMode
