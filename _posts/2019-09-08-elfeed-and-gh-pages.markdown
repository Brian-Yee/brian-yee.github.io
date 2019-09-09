---
title:  A Case for RSS & Getting Started with Elfeed
date:   2019-09-06 00:00:00 +0530
layout: default
categories: [""]
author: Brian Yee
---

Where Does Your Job Fall in Maslow's Hierarchy of Needs?
========================================================

The knee-jerk answer to the question posed in the title of this section for most people is probably
to say within the portion of self-actualization. This occurs for a combinative factor of two
reasons

1. We want to believe that we are spending a third of our day working _towards_ something
2. We are conditioned to _virtue signal_ the importance of hard-work and dedication

Indeed, the majority of friends I have discussed this with strongly believe that work is how one
self-actualizes and yet so many of my friends feel they are not self-actualizing at work. The
problem here is one of communication, everyone has an "average" understanding of what _work_ means
but there are a multitude of words each embedded with their own subtle nuances and contexts that
can mentally jam one's thought process. This paragraph has surreptitiously drifted from the
original discussion of a _job_ to that of _work_ and it is quite apparent in our society that while
we value hard-work, many people enjoy fantasize about slacking off _at their job_. I am referring to
the films such as Office Space or Clerks (or Clerks II) or even how incompetence and not working at
"a job" is portrayed in sit-coms such as Friends, Seinfeld or How I Met your Mother. There is a
modern misalignment with what we do for one-third of our day in a "job" and what we "work" towards
in our career.

This misalignment was first articulated by philosopher Hannah Arednt's in her late 1950s work [The
Human Condition](https://en.wikipedia.org/wiki/The_Human_Condition_(book)) and distinguished into
three forms of activity, two of which, that of _work_ and _labour_ are pertinent to our discussion
here<sup>[1](#action)</sup>. To Hannah Arednt _labour_ is not confined to physically toil in the
hot midday sun but rather an action that a being takes to ensure that it will continue to exist.
Anything that puts food on the table is one's labour, anything that is done to keep the fires lit
is labour. Any job where you stand around waiting for instruction to ensure you can eat despite
it's lack of physical demand is labour. Contrastingly, _work_ is what is done when _labour_ is
taken care of. After the wood is split and piled, after the chewing of one's dinner has finished,
after your required cup of morning coffee has been drunk can your _work_ potentially begin.

Maslow's Hierarchy of needs is unidirectional. It is suggestive that each level builds atop the
other to the forward progress of self-actualization but in doing so helps us forget the maintenance
required of the bottom portion of the pyramid. The modern economy seems to have _mixed_ one's work
and labour to varying degrees of imbalance obfuscating the original question from individual to
individual about how their job makes them feel. The majority of us _want to work_ but so much of us
get caught up in the laborious aspect of the day-to-day dealings that occur in our lives. John
Maynard Keynes thought automation would be the _fruits of our labour_ and dissipate the amount of
labour [required of our grandchildren](http://www.econ.yale.edu/smith/econ116a/keynes1.pdf) (by the
year 2030 or so). Today we see the automation of labour has beget us more labour, although perhaps
a more foreign and bizarre kind than Keynes could've been expected to account for.

Tangled Up in Web 2.0
=====================

These concepts are why I am strongly torn about the cult of modern productivity. When we optimize
our day what are we optimizing it for? Is it to do reduce labour or enable us to clear the way for
ourselves _working_ towards _our life's work_? The answer is -- as always -- a bit of both and the
ratio of these components vary from person to person. This idea of "what we clear the way for" is
fleshed out in the works of one of Hannah Arendt's lovers: Heidegger, author of [Being and
Time](https://en.wikipedia.org/wiki/Being_and_Time), voted as the second most important [modern
classic](https://www.stephanwetzels.nl/docs/Lackey-What-are-the-modern-classics.pdf) by
philosophers in December of 1999. As pertaining to this discussion, Heidegger outlines a theory
placing humans fundamentally as beings that _take care of things_. Everyday we "_take care_" of
things on our to-do list and consider what other humans to-do lists are through acts of empathy.
Heidegger believes that the way to primarily understand humanity is in their day-to-day actions
that he called _everydayness_. Most of the time we absolve our responsibility and chance for a
uniquely genuine interaction in our day-to-day with other humans being by discussing _everyday_
things like the weather or not discussing anything at all as we stand in an elevator awkwardly.

Our personal actions feel justified by us convincing ourselves "_that is just what one does_" never
giving ourselves the emotional chance to interact with the stranger in the elevator or talk about
something more heady than weather. This action is not posed as a universal negative but rather
simply a state of humans that we observe as exceptionally common but not questioned or originally
justified. In absolving the responsibility for interaction we can enter deficient modes of
_alienation_ where we so longingly desire to talk to another but simply don't know how. This
avoidance becomes worse as we miss oppurtunities to reach out to one another further cementing our
patterns of alienation. This "motion" is referred to as becoming _entangled within oneself_. Speech
that promotes this alienation via entanglement within oneself is referred to as _gossip_ and
textual form:_scribbles_.

Today it feels the majority of content on the web is _gossip_ and _scribbles_ precisely because the
majority of algorithms are written in a way to optimize the mass appeal of a piece. The [Internet
is an SEO landfill](https://docs.sendwithses.com/random-stuff/the-internet-is-an-seo-landfill). How
numb have I become to the end of videos saying "[smash the like
button](https://knowyourmeme.com/memes/smash-the-like)" or waiting 5 seconds to skip an otherwise
3-minute ad? What is surfaced to us is what is surface-able and the more surface-able something is
the more _gossip_-like it has to be to of reached us. We have become more concerned about
presentation and distribution than _content_. There is no doubt great content exists but we as
humans are often bad at getting to it before we are distracted, and so we browse and browse hoping
for genuine human interaction but all we find is what was findable and jadedness sets in as more of
what we see becomes [a copy of a copy of a copy](https://en.wikipedia.org/wiki/Simulacrum).

RSS to Reduce the Chatter
=========================

RSS at it's core is a way to see when a site has a new post from a set of defined URLs. These
could be: a blog you follow, links on HackerNews that were upvoted more than 250 times, every
article from a news website or even Wikipedia's Image of the Day. You an update the list, mark
things as read or bookmark important articles you really enjoyed. One option for an RSS client is
elfeed (Emacs Lisp Feed) which is launched via `M-x elfeed` and presents you with the current
buffer:

![Screenshot of elfeed](../images/elfeed/elfeed-example.png)

If it looks ugly -- good -- that means you are concerned only with the content. You can remove
something from your list by pressing `u` which launches the `elfeed-search-untag-all-unread` in the
background or open a link in your browser with `Shift + Enter`. If your in an off-line mode you can
still view your content such as the days news.

![Screenshot of elfeed article offline](../images/elfeed/elfeed-offline.png)

Your content is search-able, non-intrusive it doesn't spy on you or pester you with advertisements
alongside the content (until you navigate to the web) it really helps you take a step back and
examine the content of what it is you are consuming. More importantly, it acts as a universal
ground truth that ensures you are kept up-to-date with what **you** consider important to keep up
to date. After a month of consistently using RSS I remember noting a certain "fog" had lifted where
I wasn't constantly asking myself had anything new appeared on HackerNews or SlowTwitch. I also
found when I was bored the ability to restrict myself from going to the forums and aggregators to
"kill some time" and rather acknowledge that nothing that I had previously ruled as important was
there and I should spend the time _working_ towards something (a piano song, a personal project, a
chapter of a book) rather than _labouring_ away to find content that I might find meaningful.

People here will protest

>Not everything has to be optimized. This is my downtime and I enjoy surfing the web!

to which I say "Okay! This is not for you then!". In this post, I will re-iterate the point drawn
above.

>This action [entanglement] is not posed as a universal negative but rather simply a state of
>humans that we observe as exceptionally common but not questioned or originally justified.

RSS is not a cure-all, it is simply a way for you to untangle yourself from getting caught up in
the bombardment and pleas of attention from the saturation of media we find ourselves awash in
today. It can aid you in _working_ towards that thing you care about by depriving yourself
something of something you turn towards moment of ambivalence... or, at the very least that is how
RSS affected me.

The Emacs Lisp Feed (elfeed)
============================

Like emacs my first attempt at using RSS was unsuccessful, I tried it through the recommended
[Inoreader]() which I would recommend for people not willing to install `elfeed` (and thereby
`emacs` as well if not installed). However Inoreader tried to cleverly read in pictures and give a
GUI to sort things and provide all possible features of RSS through various actions on a dashboard.
This felt like a lot of machinery to add for something that was promised to simplify my life and
thus there was a bit of friction that developed inhibiting the development of the habit. The
solution was to seek out simpler RSS feed that acts much more predictably (i.e. in modern lingo,
not "smart" but "dumb") through the `emacs` package `elfeed`.

Installing `elfeed` is quite simple, `emacs` is perhaps a little harder. If you're on a Mac and
lazy you can download a `.dmg` [here](). If you are new to installing packages in emacs it can seem
a bit intimidating but it is arguably simpler than using `pip` for `python` modules. Just as `pip`
goes to a central module repository `emacs` has a central repository called Melpa. Start off by
launching `M-x package-install` and submitting `elfeed`. It is very likely you will experience a
failure -- this happens when Melpa is outdated we can update the source of the package by using
`M-x list-packages` which will load a special buffer listing all packages available on Melpa. It
is possible that your key-bindings in this mode will be largely disabled (e.g. half page jump `C-d
[evil-scroll-down]`or search `/ [evil-ex-search-forward]`) so to speed things up use the scroll
function on track pad or mouse. Navigate to the `elfeed` package and click it or press enter. You
should see a mini-buffer populate that looks like the following

![Screenshot of my package-install](../images/elfeed/elfeed-package-install.png)

Try installing from Melpa here _and if that fails_ install from the alternative source also
provided. Once you're done run `M-x elfeed` to launch the elfeed buffer and you will likely be met
with a blank screen -- this is because you have no RSS Feeds -- so lets add one! Execute `M-x
elfeed-add-feed` and type in my RSS `http://brianyee.ai/feed` this will automagically save your
added feed to a tuple loaded on startup. If you wish to see where it loaded it to the most robust
way is to navigate to your `.emacs.d` folder and type

```bash
grep -r brianyee.ai .
```

which will locate the URL you just saved and print the file location of _where your configuration
saves it_ to screen. Given I use the DOOM flavour of emacs it is saved in `./.local/custom.el`

```elisp
(custom-set-variables
...
 '(elfeed-feeds
   (quote
    ("http://brianyee.ai/feed" ...))))
...
 ```

If you ever need to delete an RSS feed (obviously not mine though!) you can always just delete it
here, just be careful, manually editing can mess up the custom file so measure twice and cut once.
Now launch elfeed (`M-x elfeed`) and run `M-x elfeed-update` to update your list -- you should see
a list of my posts show up! Now all we need to do is find other RSS feeds to pop up alongside it!

How do I find an RSS URL?
=========================

Up to this point we should now have `elfeed` successfully installed and know how to add RSS feeds to
it. The only question remaining is how do we find RSS feeds on the sites we want?

1. Look for an RSS icon on a page or search for "RSS" (works ~5% of the time)
2. Try adding `/feed` at the end of a website this works (works ~80% of the time)
3. Open dev console `f12` and look in the header of the page HTML you may find an indication of RSS
   in there as well (works ~90% of the time)

In the case that none of the above works your site may simply not support RSS. In this case go to
your search engine of choice ([StartPage]() or [DuckDuckGo]() come to mind) and see if anyone has
made a custom RSS feed for your site. A good example of where this is needed is if you wish to
create an RSS of [HackerNews](https://news.ycombinator.com/) which [somebody has made an RSS
for](https://edavis.github.io/hnrss/) that allows you to filter by amount of upvotes.

How do I make an RSS URL for GitHub Pages?
==========================================

Now that you have RSS feeds you may want to contribute back -- this part is _insanely_ simply. Open
up your `_config.yaml` file and type the following

```yaml
gems:
  - jekyll-feed
```

GitHub pages has a list of supported gems that you can add one of which is `jekyll-feed` made
precisely for serving an RSS feed for your website. Now push the changes of the `_config.yaml` to
your website, grab the feed and add it to `elfeed` so you can make sure that it works!

Summary
=======

We have found a way to integrate RSS into our lives, the benefit of which is highly debatable but
motivated by my own experience loosely constructed around motivating the need for optimizing life
to free up time for pursuing things outside of RSS. In summary, I argued for RSS as a way to avoid
getting tangled up in the web's interface and using a simpler interface which helps to confine the
very natural urge to browse and explore to a curated list set out by the individual. How to setup
the excellent `elfeed` in `emacs` and find RSS URLs to populate it was shown and finally how to
create your own RSS URL in GitHub pages using Jekyll was provided.

A Final Note
============

When I started this post I had in mind the vision of motivating _programmers_ specifically to take
up RSS. The reason being that the field demands a higher level of commitment outside of external
hours than many other jobs. Many of my friends believe this entails following HackerNews, BetaKit,
TechCrunch, Reddit, LinkedIn and Twitter just to name a few. Many of my friends also feel that
there is an unfair over reliance on personal portfolios throughout the interviewing process,
inhibiting their ambitions. It is my own opinion that constantly following all tech aggregators can
_entangle_ you into believing that you need to write something _worthy_ of being featured on HN,
BK, TC, etc, etc. The joy of writing small applications that do stupid things is lost and what they
consider "work outside of work" is actually _labour_ arising from the entanglement of societal
expectations viewed through aggregation websites and a lack of time to do personal projects do to
interacting with those websites.

I wanted to write this post for them or for future friends who feel this frustration and pose RSS
as a way to help solve that feeling of lost time but was unable to. Another personal goal which
contrasts this is the need to to consistently write and not worry about the perfection of a piece
of writing. So I have left this note here to ham-fist this point into the post. It is perhaps ugly
but let us view it as a patch applied under a deadline. RSS helps free time and in that free-time
we will fill it with other things many of which will contrast each other and will perhaps make us
ask ourselves the question posed near the top of this post: "What am I optimizing for?". Still, the
act of creation and _working_ towards imperfection is often better than the _labour_ of trying to
navigate a suite of websites to "stay-up-to-date". Next time a piece of content from a personal
blog surfaces through my RSS which like this one is imperfect and would not be upvoted on an
aggregator website; I will emphasize with the author and know that another human, somewhere in the
world is trying their best to self-actualize and ideally they are _working_ towards it instead of
_labouring_.

Footnotes
----------------------------------------------------------------------------------------------------

<sup>[1](#action)</sup>: The third type of activity _action_ is also pertinent to our discussion of
RSS but revolves more around the _production_ of an RSS feed which is brought up near the end of
this post too far away to cohesively motivate it within the beginning -- at least within the scope
of editing I can assign to a weekly blog post.
