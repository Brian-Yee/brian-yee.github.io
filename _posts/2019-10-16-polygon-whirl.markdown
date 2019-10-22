---
title:  Generating Textured Pentagonal Tessellations
date:   2019-10-20 00:00:00
layout: default
categories: [""]
author: Brian Yee
---

**Full code to tinker and play with is available on
[GitHub](https://github.com/Brian-Yee/whirl-tesselations)**

Seeking Simple Inspirations
===========================

I try to post to this site once a week for 3 main reasons

1. It breeds consistency and consistency breeds improvement
2. It keeps topics of what I research fresh or encourages me to read more for inspiration
3. It is useful exercise in scoping projects.

Unfortunately I just broke a 9-week streak in which I posted 10 posts spread out so as to avoid a
week gap in between any. Moving houses, Thanksgiving and a birthday simply added too much to my
plate. If I was hoping for a breather this weekend unfortunately the next four days (as I write
this on Wednesday) include:

- Tonight: Get my hair-cut and shave so I don't look like a ragamuffin
- Thursday: Catching up with a good old-friend and a farewell party to send another friend off to
  Europe
- Friday: Catching up with a couple of friends I was in the wedding party for and a night at the
  opera followed by post-opera wheaty-pops<sup>[1](#beer)</sup>
- Saturday-Sunday: Finish off unpacking/setting things up

As the saying goes: "When it rains, it pour-duces a bunch of rain-checks that all fall on the same
date!". Okay so that's not the saying but the point is if I want to push out a decent quality post
for this Sunday I need pump out this post during my train commuting time. I have a backup reserve
of ideas that I can write about depending on time-restrictions and I was lucky this one turned out
so well given I deprived my audience of a post last week!

Whirls
======

A [whirl](http://mathworld.wolfram.com/Whirl.html) is a series of nested regular polygons
iteratively rotated and shrunk at every step. You can view their construction in the following gif.

<p style="text-align:center">
    <img alt="Construction of a triangle whirl" src="../images/pentagon/whirl3.gif">
    <img alt="Construction of a square whirl" src="../images/pentagon/whirl4.gif">
    <img alt="Construction of a pentagon whirl" src="../images/pentagon/whirl5.gif">
    <img alt="Construction of a hexagon whirl" src="../images/pentagon/whirl6.gif">
</p>

It turns out the corners of the regular polygons trace out a line that is equivalent to the
solution of a math problem simply called the [mice
problem](http://mathworld.wolfram.com/MiceProblem.html). The problem is concerned with the
following two step situation below

1. Place a mouse in the corner of each regular polygon
2. Have each mouse chase the mouse closest to them clockwise.

the question we seek to answer is quantifying what curves each of the mice produce. It turns out
that in the continuous limit they produce a [logarithmic
spiral](https://en.wikipedia.org/wiki/Logarithmic_spiral). Here's another gif that shows there
construction below

<p style="text-align:center">
    <img alt="Simulation of a triangle mice problem" src="../images/pentagon/mice3.gif">
    <img alt="Simulation of a square mice problem" src="../images/pentagon/mice4.gif">
    <img alt="Simulation of a pentagon mice problem" src="../images/pentagon/mice5.gif">
    <img alt="Simulation of a hexagon mice problem" src="../images/pentagon/mice6.gif">
</p>

A whirl can be viewed as a discrete approximation of the mice problem where lines have been drawn
between the neighboring mice at each step.


Pentagonal Tessellation
=======================

If we look at the gifs above. One of these shapes is not like the other: the triangle, square and
hexagon can all tessellate the plane but the pentagon _cannot_. Note that I said the pentagon _in
those gifs_, that is, a _regular_ polygon with all sides _equal_ in length. If we drop this
restriction it turns out that there is a surprisingly rich area of research on possible irregular
pentagon tessellation that recently reached a milestone in 2015 when researchers after [30
Years](https://www.quantamagazine.org/pentagon-tiling-proof-solves-century-old-math-problem-20170711/)
discovered a new type of pentagon that tiled the plane and furthermore proved that this was the
last possible irregular pentagon to tile the plane.

It turns that there are 15 ways to tile the plane 2 of which I find particularly interesting. Many
of the pentagons can be constructed by considering varying parameters that can be satisfied in a
way to produce a set of irregular pentagons which form a certain _type_. Each of these types is
said to be _under-constrained_ as it has various tunable parameters that can determine a
tessellation of the plane. Each of these tunable parameters is referred to as a degree-of-freedom.
Two out of the fifteen types have 0-degrees of freedom and furthermore were the last two to be
found!

<p style="text-align:center">
    <img alt="Type-14 pentagon" src="../images/pentagon/type-14.png">
    <img alt="Type-15 pentagon" src="../images/pentagon/type-15.png">
</p>

While the type-14 and type-15 tilings (left most image above) may look complicated there is a
two-step process that can reduce the complexity of the problem. The trick is that using the
_base-tile_ requires one to do do bookkeeping of flips, rotations and translations. However one can
focus on building a _super-tile_ (right most image above) that _only_ requires translations. With a
set of _basis-vectors_ we can then translate the super-tile to form a tiling of the plane. For
example below is one possible super-tile for the type-15 pentagonal tessellation. To make this
symmetry more explicit I have explicitly highlighted the 12-tile super-tile ontop of a tesslation
below

<p style="text-align:center">
    <img alt="Type 15 pentagon tessellation super-tile" src="../images/pentagon/supertile.png">
</p>

Thus we have encoded all the burdensome calculations of the flips and translations up front in the
calculation of some mathematics in defining the super-cell. Luckily (given how pressed I am for
time this week) these calculations are available via one of the [external links] on the Wikipedia
page although they are written in JavaScript. After a quick port to Python we can now have the
ability to produce a set of vertices in space which can be connected to form the type-14 and
type-15 tilings.

Let it Whirl
============

We have up to this point described both a [whirl]() and [pentagonal tessellations](). However, the
framework we described extended whirls to convex polygons in general so we can still plot the
regular polygon whirl tesselations as well! All that is left now is to combine the whirls and
tessellations and let the results speak for themselves!

Square
------
[![Square whirl tiling of plane](../images/pentagon/square.png)](../images/pentagon/square.png)

Hexagon (with Holes!)
---------------------
[![Hexagon partial whirl tiling of plane](../images/pentagon/hexagon.png)](../images/pentagon/hexagon.png)

Triangle
--------
[![Triangle whirl tiling of plane](../images/pentagon/triangle.png)](../images/pentagon/triangle.png)

Pentagon Type 14
----------------

[![Type-14 whirl tiling of plane](../images/pentagon/whirl-14.png)](../images/pentagon/whirl-14.png)

Pentagon Type 15
----------------

[![Type-15 whirl tiling of plane](../images/pentagon/whirl-15.png)](../images/pentagon/whirl-15.png)

Conclusion
==========

We have extended the use of a whirl to arbitrary convex polygons by using a discrete version of the
mice problem. We then applied this generalization to a pentagonal tessellation of the plane with no
degrees of freedom. The results speak for themselves in their gorgeousness and mesmerizing nature!


**Full code to tinker and play with is available on
[GitHub](https://github.com/Brian-Yee/whirl-tesselations)**

References
==========

<sup>[1](#beer)</sup>a.k.a. Beer

Additional Notes
================

After writing this article I learned that this generalized convex polygon whirl is very similar to
a [derived polygon](http://mathworld.wolfram.com/DerivedPolygon.html). At the very least it appears
that as the fractional distance approaches zero the result approaches the genralized whirl
constructed from the moust problem.
