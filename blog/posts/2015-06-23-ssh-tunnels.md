---
title:  "SSH Tunnels Rock !!"
---

Let's say you have the following servers running for your web application:

- `app.com`
- `db.com`

You like to fiddle with the database at `db.com` but for security reasons only `app.com` can access `db.com`. You can ssh into `app.com` and access `db.com` but it wouldn't always work if a mysql client doesn't exist on `app.com`. You can rely on ssh tunnels to solve this problem.

By creating a tunnel, you can access `db.com` as if it were running locally (on port 5000 in the example below):

```
ssh app.com -L 5000:db.com:3306 -N
```

We are instructing the ssh utility to create a tunnel that can redirect your traffic to `db.com` via `app.com`:

- Forward all traffic coming on `localhost:5000` to `app.com`
- All traffic terminating on `app.com` within the tunnel is redirected to `db.com:3306`

Now you can try:

```
mysql -h 127.0.0.1
```

**Note:** Use `127.0.0.1` to create a network socket and not `localhost` which will use a unix socket instead.

Gven that you have ssh access, you can **control the traffic on a remote server** with a simple command and **use locally installed utilities to use services available on remote machines**. The syntax is not so intuitive at first, but once you get a hang of it, this is really powerful!
