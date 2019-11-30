---
title:  How to (Securely) Version Control Your Credential Files
date:   2019-11-16 00:00:00
layout: default
categories: [""]
author: Brian Yee
---

Drop, Pop & Lock
================

Over the long weekend I found myself playing with the Spotify API to programatically build myself
some playlists which I plan to discuss in a future post. For now, I would like to touch base with
my blog by discussing part of that project, specifically the aspect in which I securely store
credential files to log into Spotify's API with. The reader is strongly encouraged to first review
my post on using [pass](pass), "The Unix Password Manager" that uses Gnu Privacy Guard (GPG,
hereafter referred to by its alias `gpg`) for secure password storage. Not only because you should
be using a password manager and `pass` is a fantastic option but because it discusses the Swiss
Cheese Model of security and why it's important for any application to _layer_ defences against
malicious agents.

In this post, I will be outlining another use of `gpg` for securely storing and distributing
sensitive information: `git-crypt`. We will see that by applying a smudge filter before and after
our commits we are guaranteed to maintain code in a cryptographically secure manner across a trust
network of computers. The functionality to cryptographically secure a set of files amongst a trust
network has immediately obvious applications for any software team.

How to Git-Crypt
================

Using `git-crypt` is extremely simple however for comfort I will walk through the whole process. We
begin by starting with initializing a repository tracked by git

```
🌊 mkdir git-crypt-demonstration
🌊 cd git-crypt-demonstration
🌊 git init
Initialized empty Git repository in /Users/<username>/git-crypt-demonstration/.git/
```

Great, now the process of adding `git-crypt` is straightforward (assuming you have installed via
source or the package manager of your choice)

```
🌊 git-crypt init
Generating key...
```

That was so easy it's almost confusing. What does it mean by it has generated a key? We can look
inside our `.git` folder to see

```
🌊 cat .git/git-crypt/keys/default
GITCRYPTKEY ��K��X��(��B�?/8�0ٮ�(W�}�@��@\[�>����'�M-��M.7KUM�Ji+��6"�ݕ�[�����{���I�	�QY�*��UԊ3A%
```

Neat so a new folder called `git-crypt` was made within `.git` and it instantiated itself with a
default key via our `init` command. Next we would like to add our key to the key-ring to expand the
trust circle to include ourselves. Doing this is easy since you definitely read the post on
[pass](pass) before this one as suggested in the first paragraph on this post!! Let's take a look
at our `gpg` keys.

```
🌊 gpg -k
/Users/<username>/.gnupg/pubring.kbx
--------------------------------------
pub   rsa2048 2019-05-19 [SC] [expires: 2021-05-18]
      6EBB5BCF3E687CB11E1A14C31FC2EF91B6DFF9C6
uid           [ultimate] username <email@domain.com>
sub   rsa2048 2019-05-19 [E] [expires: 2021-05-18]

...
```

where `...` are other lines discussing keys that may be available. Lets add our
email

```
🌊 git-crypt add-gpg-user "username <email@domain.com>"
[master (root-commit) 18b0b49] Add 1 git-crypt collaborator
 2 files changed, 4 insertions(+)
 create mode 100644 .git-crypt/.gitattributes
 create mode 100644 .git-crypt/keys/default/0/6EBB5BCF3E687CB11E1A14C31FC2EF91B6DFF9C6.gpg
```

clearly our public key is now stored in the `.git-crypt` repository. Taking a look at our history

```
🌊 git log --oneline --graph --all --decorate
* 18b0b49 (HEAD -> master) Add 1 git-crypt collaborator
```

We see that we have added one git-crypt collaborator. Finally we will create and edit the
`.gitattributes` to instruct `git-crypt` to encrypt our sensitive file, better yet lets encrypt
everything within a credential folder.

```
🌊 echo "creds/* filter=git-crypt diff=git-crypt" > .gitattributes
🌊 git add .gitattributes
🌊 git commit -m "Update git-crypt file."
```

Now lets touch some files to see if we did everything right.

```
🌊 mkdir creds
🌊 echo "secret" > creds/secret.json
🌊 echo "juicy secret" > creds/juicy_secret.json
🌊 touch just_a_plain_ol_python_file.py
🌊 git add creds just_a_plain_ol_python_file.py
🌊 git commit -m "Add some juicy secrets."
```

We can now inspect the status of our files with the following command

```
🌊 git-crypt status
not encrypted: .gitattributes
    encrypted: creds/juicy_secret.json
    encrypted: creds/secret.json
not encrypted: just_a_plain_ol_python_file.py
not encrypted: .git-crypt/.gitattributes
not encrypted: .git-crypt/keys/default/0/6EBB5BCF3E687CB11E1A14C31FC2EF91B6DFF9C6.gpg
```

and verify they are encrypted by `cat`ing them

```
🌊 cat creds/juicy_secret.json
juicy secret
```

WOAH -- wait I thought `git-crypt` said it was encrypted!! It _will_ be encrypted _when_ you `push`
the changes using git's `smudge` command. Go ahead -- push our test repo and look at what the
`juicy secret` looks like online. Currently in an offline mode they are stored _unencrypted_ so you
can actually use them! That is for example to be loaded thorough the `json` module and access the
contents to authorize an API client. If you would like them encrypted locally as well (which is the
default state they are `pull`ed as) you can instruct `git-crypt` to do that as well

```
🌊 git-crypt lock
🌊 cat creds/juicy_secret.json
GITCRYPT�g���;��$���5�E�ͭ:�YH�%
```

Now we see it as it appears online and on the initial `pull`. Supposing we did pull down the
secrets _to a computer within our trust circle_ we would first have to unlock the repository.

```
🌊 git-crypt unlock
🌊 cat creds/juicy_secret.json
juicy secret
```

I would like to stress again that the only people that can unlock the credentials are people who
you have explicitly added via the `git-crypt add-gpg-user` command via an individual already in the
trust circle. For more information on this please refer to a discussion of `gpg` in my previous
post about [pass](pass).

Summary
=======

I have given a detailed walkthrough of getting started with `git-crypt`. This walkthrough should
give a newcomer an end-to-end example that they can start toying with to see what special states
their repos fall into and what `git-crypt` other messages will be thrown (or not). As a
continuation to build confidence and skill try setting up `gpg` on another computer and try adding
them via `git-crypt add-gpg-user` to the `.git-crypt` repo so they can unlock the files elsewhere.
It's a short post this week so that's it for the summary. Take the usual amount of time you would
have to spend reading the rest of my rambles to try out this very useful skill for yourself!
