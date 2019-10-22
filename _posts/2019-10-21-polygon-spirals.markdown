---
title:  Polygon Spiral Art
date:   2019-10-23 00:00:00
layout: default
categories: [""]
author: Brian Yee
---

Digging Up the Past
===================

**Full code to tinker and play with is available on
[GitHub](https://github.com/Brian-Yee/PolyWhirl)**

My prior blog post on [Convex Polygon Whirl Tesselations]() discussed the importance of seeking
simple inspirations and properly scoping blog posts to adhere to a personal goal of one post a week
on average. It also bemoaned about the amount of things that have currently all seemed to cluster
together in time for me to attend to. Now before I bemoan any further I would like to acknowledge
that these are, in fact, good problems to have. I am grateful that I have the opportunity to move
somewhere, see operas and catch up with friends. However, just as one can still be grateful for
attending a buffet and be stare down intimidatingly at the cornucopia ensemble of their plate and
question if there eyes were in fact too big compared to their stomach, one can also stare at the
joys of life and feel they piled too much on too close and should rather in the future aim to
spread out the good stuff.

Dragging out this metaphor further just as one has a responsibility to eat what they put on their
buffet plate, there exists a responsibility for me to continue the goals of my life amidst the joys
which take up time. This week has the following time restrictions

- Tonight: A second opera! La Boheme, but this time up close and personal in a bar as part of the
  Against the Grain Tour
- Tomorrow: A day off of work to unpack, organize and move furniture followed by a plane at 12:35
  at night
- Thursday-Friday: The Deep Learning Montreal Summit
- Saturday-Sunday: Visiting Montreal friends while we are in the neighbourhood and engagement
  photos at the lights festival.

Ooph, if I'm going to remain consistent and practice my writing skills and appease the wide RSS fan
base of the 4 people who follow this site I better find something fast to write about! Luckily for
me during my trip to Spain earlier this year while on the plane I wrote a small simple program that
has in the `~/github` directory of my laptop that I can play with on my commutes to post the
results here!

A Mundane Plane to Spain Refrain
================================

A while ago I went to Spain with my fiancee for her to compete in a triathlon and piggy back from
there to Finland to settle a bar-bet. Sitting in the surprisingly Cozy Hamilton airport, I thought
of the long plane ride ahead and the potential lack of good movies and terrible airplane programmed
chess games<sup>[1](#chess)</sup>. Determined to make the most of my time I spent the time browsing
[Wolfram Mathworld]() and try to find some simple ideas that I could implement on the plane. One of
article that looked exceptionally simple and caught my eye was that of polygon spirals. A sequence
of polygons with nested polygons determined by vertices located at the midpoint of the previous
iterations vertices. From these consecutively nested vertices, one can construct a spiral rotating
inwardly and calculate some fun properties

<p style="text-align:center">
    <img alt="Polygon Spirals" src="../images/polywhirl/polygon-spiral.gif">
</p>

Furthermore, spirals can be joined to calculate more mathematically fun properties

<p style="text-align:center">
    <img alt="Polygon Spirals" src="../images/polywhirl/polygon-wedge.gif">
</p>

For example the shaded region of the polygon wedge is a rep-4-tile that can tessellate the plane in
a very special manner. You can refer to my [prior post on
this](2019-09-02-beautiful-rep-tiles.markdown) for more information on rep-tiles and their specific
properties which are interesting in and of themselves.

Construction
============

Constructing a polygon spiral is quite easy with a bit of background in polar-coordinate systems
and dead easy with a little knowledge of complex analysis. We begin by expressing a polygon of
\\(n\\)-sides via the following collection of points in polar form.

$$
\text{polygon}_{(i, n)} =
\left\lbrace
\left(
r, \frac{2\pi}{\text{mod}(i + k, n)}
\right)
|
k \in (0, 1, 2, ..., n)
\right\rbrace
$$

Due to it's polar form this can be expressed as a collection of points in the complex plane.
Allowing us to touch base and adopt a more familiar notation, although continuing to adopt our use
of the subscript to denote the ordered set.

$$
z_{(i, n)} = \text{polygon}_{(i, n)}
$$

We then note that the midpoints between each radius can be defined in the following manner

$$
\text{midpoint} = s \left(\frac{z_{(1, n)} - z_{(0, n)}}{2}\right)
$$

where we have introduced \\(s\\) as a rescaling factor. This rescaling factor can be readily
computed from the norm of two clock-wise adjacent points in the plane.

$$
s = \frac{| z^{j + 1} - z^j |}{|\ z^j\ |}
$$

Where we have introduced a superscript notation to denote picking any arbitrary point from an
ordered set. With these definitions the `main` function of our program in Python is now readily
discernible

```python
thetas = np.linspace(0, 2 * np.pi, num_sides)
polygons = [Polygon(1, thetas)]

while polygons[-1].radius > inner_radius_cutoff:
    dual_thetas = polygons[-1].thetas + np.diff(polygons[-1].thetas[:2]) / 2
    midpoint = [
        polygons[-1].radius * func(-polygons[-1].thetas[:2]).sum() / 2
        for func in (np.cos, np.sin)
    ]
    self_dual = Polygon(np.linalg.norm(midpoint), dual_thetas)

    polygons.append(self_dual)
```

where the `Polygon` class generates the ordered set as defined initially defined.


Spiral
======

Applying our code above and applying a gradient `cmap` we achieve the following results for filling
in all wedges.

<p style="text-align:center">
    <img alt="Filled triangle wedges" src="../images/polywhirl/triangle.png">
    <img alt="Filled square wedges" src="../images/polywhirl/square.png">
    <img alt="Filled pentagon wedges" src="../images/polywhirl/pentagon.png">
    <img alt="Filled hexagon wedges" src="../images/polywhirl/hexagon.png">
</p>

If we crank up the number of sides we can make a concentric ring illusion

![Concentric ring illusion](../images/polywhirl/illusion.png)

Although that is quite jarring on the eyes, if we use a modulus option to only fill in the wedges
at a certain interval we can create a more pleasant spacing.

![Example of polywhirl output with large n and modulus
usage](../images/polywhirl/modulus-spiral.png)

Summary
=======

We have discussed the simple concept of a [polygon
spiral](http://mathworld.wolfram.com/PolygonalSpiral.html) and extended it to create some beautiful
images. The post this week was shorter than usual because of life commitments but on the brightside
it's great that my weekly post goals have encouraged me to resurface old content. Now I will push
this from the airport as I feel the eyeballs in the back of my skull.

Footnotes
=========

<sup>[1](#chess)</sup> Seriously what's up with this? If anybody has insider knowledge on this
please send an email (once I set that up on this site) to me! It's been 3 decades since Deep Blue
and there are plenty of open source engines, why is it that airplane chess game engines are so bad?
On my trip to Wales last year I was surprised to find that the both the Othello and chess game
engines were unapologetically bad. My hypothesis is that to avoid needing to organize many wires
across the plane each airplane seat has a small processor dedicated to being integrated into the
back of the head-rest of a plane seat. While this should still be plenty of compute the amount of
space dedicated to other services -- especially videos -- is probably provisioned to an extent that
the space allocated for games is tiny. This is fine for zero-player games such as blackjack and
sudoku but for non-zero player games the amount of space dedicated must be too small to provide an
entertaining game for anything but the lowest ELOs.
