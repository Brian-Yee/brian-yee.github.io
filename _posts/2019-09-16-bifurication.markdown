---
title:  Chaos, Cobwebs and Bifurcation Diagrams
date:   2019-09-22 00:00:00
layout: default
categories: [""]
author: Brian Yee
---

Chaos Theory in My Formative Years
==================================

When I was but a wee young lad firmly placed within my awkward teenage years, I (like all other
teenagers before me) felt the compulsive urge to _stick it to the man_ and individuate from adults
by pursuing my own self interests. I was also a massive physics dork. These two qualities
manifested in reading _"edgy"_ math and physics texts. I'm talking stuff like the Wikipedia Page on
[_White Holes_](https://en.wikipedia.org/wiki/White_hole) because black holes are so passe or
reading books that attack modern physics like [The Trouble with
Physics](https://en.wikipedia.org/wiki/The_Trouble_with_Physics) or e-mailing the author of [The
Strange Business of Doing Crazy Science]() for career advice<sup>[1](#email)</sup>. I also read
mathematics books like [Why do Busses Come in Threes](https://en.wikipedia.org/wiki/Rob_Eastaway),
risque Wikipedia articles on [Sexy Primes](https://en.wikipedia.org/wiki/Sexy_prime) or watched
episodes of [NUMB3RS](https://en.wikipedia.org/wiki/Numbers_(TV_series)) where they used math to
catch the baddies. At the time, I couldn't imagine a time when as an older adult I would not be
entranced with these subjects but have a much deeper respect form. Bruce Lee has a quote on this I
quite like

>Love is like a friendship caught on fire. In the beginning a flame, very pretty, often hot and
>fierce, but still only light and flickering. As love grows older, our hearts mature and our love
>becomes as coals, deep-burning and unquenchable.
>
>~Bruce Lee

One of the subjects I thought was _super cool_ and set me down the path of studying relativistic
fluid dynamics and statistical physics was Chaos Theory, specifically a book called
[Chaos](https://en.wikipedia.org/wiki/Chaos:_Making_a_New_Science) by [James
Gleick](https://en.wikipedia.org/wiki/James_Gleick). At the time I revered Chaos Theory in a holy
reverence similar to the view of nature [Spinoza](https://en.wikipedia.org/wiki/Baruch_Spinoza)
felt<sup>[2](#chaos)</sup>. The topic name is just so damn _tantalizing_. Today, I hardly think
about these things but have a deeper appreciation for it and still enjoy sharing that appreciation
with others. To this end, I have re-written from my memory the highlight of the
[Chaos](https://en.wikipedia.org/wiki/Chaos:_Making_a_New_Science) book here so readers can better
grasp what is meant by Chaos Theory when it arises next. I highly encourage anyone who finds this
post interesting to [read the book](https://en.wikipedia.org/wiki/Chaos:_Making_a_New_Science)!

You've probably heard the term Chaos Theory, perhaps in discussions of popular media like [The
Butterfly Effect](https://en.wikipedia.org/wiki/The_Butterfly_Effect), [The Die Episode of
Community](https://www.imdb.com/title/tt2060963/), or
[Steins;Gate](https://en.wikipedia.org/wiki/Steins;Gate). As such, most people have a general idea
about what it entails that goes like this:

1. Take some complicated system
2. Make a small change at the start
3. Things end up wildly different at the end

and this isn't necessarily wrong, it's just that there can be so much more! Especially because
Chaos Theory is a fantastic breeding ground for **beautiful** pictures of mathematics. Today I'm
reminiscing on my past to discuss bifurcation plots.

These Ain't Your Boring High-school System of Equations!
======================================================

First lets set something straight, the average understanding of Chaos Theory is more philosophical
than it is technical. If we consider the first point outlined in the previous section as the
starting point for our understanding of Chaos Theory (take some complicated system) we will find an
inherit bias that accidentally slipped into our philosophy. It is the term "_complicated_" applies
not to the _system_ but to the _behaviour of the system_. That is Chaos Theory takes _simple
systems_ and sees what _complex behaviour arises from them_<sup>[3](#Occam)</sup>.

One of the simplest systems we can build is a _dynamical system of equations_. We start with just a
system of equations

$$
\begin{align}
    f(x) &= r x (1 - x)\\
    g(x) &= x
\end{align}
$$

both of these are simple and readily plotable, we have added a value \\(r\\) to add one tunable
parameter to play with. Plotting values for \\(r = 1\\)

<p style="text-align:center">
    <img alt="System of equations for the logistic function" src="../images/bifurcation/cobweb-0.png">
</p>

We then make them _dynamic_ by feeding in the output of one into the other

$$
\begin{align}
    f(g(x)) &= r g(x) (1 - g(x))\\
    g(f(x)) &= f(x)
\end{align}
$$

we see that the RHS of the first equation is almost equal to the RHS of the second equation. In
fact it doesn't take much effort to make them equal at all

$$
\begin{align}
    f(g(x)) &= r g(x) (1 - g(x))\\
    g(f(g(x))) &= f(g(x))
\end{align}
$$

substituting we now have

$$
\begin{align}
    g(f(g(x))) &= r g(x) \left(1 - g\left(x\right)\right)
\end{align}
$$

we start with \\(g(x)\\) and than pass through some intermediate function \\(f(x)\\) only to pass
it through \\(g(x) again\\), that is _after one iteration_ we arrive _back where we started_. This
allows us to write the system in terms of a _recurrence relation_

$$
\begin{align}
    g\left(x_{n+1}\right) &= r g\left(x_n\right) \left(1 - g\left(x_n\right)\right)
\end{align}
$$

but let us not forget that \\(g(x) = x\\)! The equation boils down to a nice compact form of

$$
\begin{align}
    x_{n+1} &= r x_n \left(1 - x_n\right)
\end{align}
$$

expressed in this way a question appears. What happens as \\(n\\) goes to infinity? Does the next
value get arbitrarily _closer_ to the the _next_ value?

$$
0 \stackrel{?}{\leq} \lim_{n \rightarrow \infty} \left| x_{n+1} - x_{n} \right|
$$

That is does our system _converge_ to a single value? The only way to find out is to simulate it.

Chaotic Cobwebs
===============

The first thing to note is that there is a __visual_ interpretation of our recurrance relation. We
choose some starting point \\(x_0\\) and can show the relation of it by drawing a vertical red line
between it and the value on the full curve of the RHS.

<p style="text-align:center">
    <img alt="Iteration one of logistic cobweb" src="../images/bifurcation/cobweb-1.png">
</p>


We next note that this value is equal to our next starting point \\(x_{n+1}\\) given our _output_
(\\(y\\)-axis) is equal to our _input_ (\\(x\\)-axis) we can encode this relation by drawing a
horizontal red line between the two.

<p style="text-align:center">
    <img alt="Iteration two of logistic cobweb" src="../images/bifurcation/cobweb-2.png">
</p>

This new value has provided us with one iteration and an equivalent starting point as if we had
begun at the new value of \\(x_1\\) so we can iterate our tracing solution indefinitely

<p style="text-align:center">
    <img alt="Constructing a cobweb plot" src="../images/bifurcation/cobweb-construction.gif">
</p>

The result is mesmerizing! This is called a **cobweb plot** and we can see that for the case of
\\(\left(x_0=0.2, r=1\right)\\) our system does converge to a value of approximately
\\(\sim0.65\\) this _fixed point_ located at the intersection of our original functions \\(f\\) and
\\(g\\)is called an _attractor_. The question now begs of itself are all intersections of \\(f\\)
and \\(g\\) attractors? We left in a value of \\(r\\) in our original definition as a tunable
parameter. This tunable parameter allows us to vary the intersection by changing it's value. Armed
with our new knowledge of cobweb plots we can observe the behaviour of the cobweb as we vary
\\(r\\).

<p style="text-align:center">
    <img alt="Example of Chaos in the Logistic CobWeb" src="../images/bifurcation/logistic-cobweb-chaos.gif">
</p>

The answer to are all intersections of \\(f\\) and \\(g\\) attractors is a resounding "No!". Some
crazy stuff went down around \\(r \sim 3\\). Furthermore for \\(r > 3\\) there appeared to be two
distinct types of behaviour _well-behaved_ and _chaotic_ a further investigation is required.

Bifurcation Diagrams
=====================

We previously demonstrated the behaviour of our dynamic systems in a `.gif` that varied our tunable
parameter \\(r\\) to show the resulting interplay of the system. To gain a more holistic view of
the system we can keep track of the states that we observe in a list and write them as a matrix of
values. However, recall our main concern is that of the long term behaviour of our system so we
will provide a _burn-in_ period of \\(1000\\) iterations before we start plotting the values. Thus
we have a scatter plot of points that I have organized to elucidate their selection from the
collection of points below

$$
(1.00, x_{1000}), (1.00, x_{1001}), (1.00, x_{1002}), \cdots (1.00, n)\\
(1.01, x_{1000}), (1.01, x_{1001}), (1.01, x_{1002}), \cdots (1.01, n)\\
\vdots\\
(4.00, x_{1000}), (4.00, x_{1001}), (4.00, x_{1002}), \cdots (4.00, n)\\
$$

In this form it becomes clear we are essentially creating a heatmap with the position of the
\\(x-axis\\) determining our tunable system parameter \\(r\\). We choose the boundary of \\([1.00,
4.00]\\) because this has system has been studied by mathematicians for quite sometime and this has
been the main interest of region. On that note now is probably a good time to bring forth that this
equation was not generated randomly. It is called the [logistic
map](https://en.wikipedia.org/wiki/Logistic_map) and is the archetypical example of how chaotic
behaviour can arise out of very simply systems for nearly half a century since 1976. With that
being said here is the bifurcation plot of th logistic map

![Example of Chaos in the Logistic Bifurcation map
](../images/bifurcation/logistic-bifurcation-map.png)

Simply gorgeous -- I thought when I was teen and I still think that now. The prettiness is not
limited solely to this system but exists in other systems as well such as the Gauss Iterated Map,
this one is interesting as it demonstrates that there is a seperate detached equilibrium depedant
on starting conditions indicated by the red line.

$$
x_{n+1} = \exp\left(- \alpha x_n^2\right) + \beta
$$

![Example of Chaos in the iterated gauss bifurcation map
](../images/bifurcation/gauss-bifurcation.png)

or the extremely simple tent-map

$$
x_{n+1} = \mu \text{min}\left(x, 1 - x\right)
$$

![Example of Chaos in the tent bifurcation map
](../images/bifurcation/tent-bifurcation.png)

Conclusion
==========

Chaos Theory sounds so impressive, tantalizing and foreboding but a little time spent playing in
the field and learning about it's simplest manifestations have given us a deeper appreciation of
what the subject actually studies and how "chaos" can arise from simple systems. We have discussed
the [logistic map](https://en.wikipedia.org/wiki/Logistic_map) a very simple equation that is
expressed as a self-recurrance relation (i.e. iterative system) tuned by a single parameter. We
observed that tuning this parameter does not always lead to chaotic behaviour but in special cases
a high amount of complexity can spontaneously arise. Still patterns remain discernible, although
perhaps not easily quantifiable. These patterns were expressed as a bifurcation diagram that shows
how the long-term behaviour of the system behaves when modified by the tunable parameter. The
reader should not be more equipped when they hear the term chaos theory to refer back to this
simple system and remember that not every perturbation leads to complexities and that it is the
complex behaviour of the system that is of interest, not necccessarily a complex system itself!


Footnotes
=========

<sup>[1](#email)</sup> To which he replied telling me to study hard, which at the time left me so
flabbergasted that I got a response from this _superstar_ since obviously there must be millions
around the world like me who wanted to be a Theoretical Physicist reading this book! Right?!

<sup>[2](#chaos)</sup> Indeed I was so passionate about the subject that I quit out of my first
year philosophy class because I had been paired up with a TA who I didn't like very much and the
tipping point came when he lectured us on Chaos Theory in one of our TA sessions. I don't recall
what he said but I remember being so annoyed by his misconveince and generalization of it that I
immediately unrolled myself from that elective after that TA session.

<sup>[2](#occam)</sup> This of course is not gospel but a general observation that there is _no
requirment_ to build a complex system by combing complex sub-parts. Occam's razor holds in ideology
hear, if the goal is to observe complex _behaviour_ why have it arise from a system that could be
distilled?
