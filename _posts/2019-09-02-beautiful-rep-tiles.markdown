---
layout: post
title:  Beautiful Geometeric Rep-Tiles
date:   2019-09-02 00:00:00 +0530
layout: default
categories: [""]
author: Brian Yee
---
Offline Spanish Rep-Tiles
=========================

**Full code to tinker and play with is available on
[GitHub](https://github.com/Brian-Yee/Py-Rep-Tile)**

Back in May I went on a trip to Spain and needed some simple concepts to program while in an
offline state. As a bonus, they would ideally be something new and not directly tied to something
productive that I had already done. I figured a geometric problem would be ideal for this as the
visual aspects make the conceptualization easy to remember and I hadn't worked on any more
math-for-math-sake's problems for quite some time. These two projects turned out to be
[PolyWhirl](https://github.com/Brian-Yee/PolyWhirl) and
[Py-Rep-Tile](https://github.com/Brian-Yee/Py-Rep-Tile). While PolyWhirl was written rather quickly
Py-Rep-Tile took a bit longer identifying an ideal solution.

Background
==========

What is a Rep-Tile?
-------------------

A rep-tile is a portmanteau of _repeating tile_ that is it is a tile that one can tesselate a copy
of itself. This property is called
[self-similarity](https://en.wikipedia.org/wiki/Self-similarity), which means the whole has the
same shape as one or more of its parts. The tile can be mirrored and rotated but the perimeter is
rigid and never augmented. You can see many examples of rep-tile's on the [wikipedia
page](https://en.wikipedia.org/wiki/Rep-tile) devoted to them.

What is Aperiodicity?
---------------------

[Aperiodicity](https://en.wiktionary.org/wiki/aperiodic) is the trait of not being _periodic_,
which is to say that there is no repeating pattern spaced across some given interval such as space
or time. A clock is periodic because after 24 hours the hands will be in the same state as before;
my sneezes are aperiodic because there is no defined interval of time that you can guarantee I will
sneeze.

Aperiodic Tilings
=================

An aperidoic rep-tile is a self-similar a aperiodic tiling across the two-dimensional space. Given
a rep-tile tiles _itself_ it is useful to construct a `subdivide` function that takes a reptile and
then partitions it into copies of itself. The easiest way to do this is to choose three central
points of a tile an _origin_, _index_, and a _thumb_.

- An _origin_ is a point common to an _index_ and _thumb_
- A _thumb_ is the shortest edge touching the _origin_
- An _index_ is the longest edge touching the _origin_

The naming of these terms are chose because the _origin_ is used as a reference point to translate
points back to the _origin_ of a plane where mathematical operations are easier. The _index_ and
_thumb_ are chosen to highlight the
[_chirality_](https://en.wikipedia.org/wiki/Chirality_(mathematics)) present in the problem from
flipping a tile. The sign of the cross product of your _index_ and _thumb_ tells you whether a tile
was flipped or not. There are two aperiodic reptiles I implemented the
[pinwheel](https://en.wikipedia.org/wiki/Pinwheel_tiling) and
[sphinx](https://en.wikipedia.org/wiki/Sphinx_tiling). Below are the diagrams showing their
geometry along with the set of equations which can define the interior points based on defining
exterior points

Pinwheel Rep-Tile
-----------------

### Diagram

{% tikz pinwheel-diagram %}
  \begin{tikzpicture}[scale=6]
  \newcommand{\phase}[1]{\text{phase}\left(#1\right)}
  \newcommand{\polar}[1]{\text{polar}\left(#1\right)}
  \newcommand{\abs}[1]{\left|#1\right|}

  \newcommand{\QR}{QR}
  \newcommand{\QP}{QP}
  \newcommand{\pinwheelTheta}{26.56505117707799}  % arctan(2, 1)

  \node(Q) at (0, 0) {P};
  \node(P) at (0, 1) {Q};
  \node(R) at (2, 0) {R};

  \node(a) at (1, 0) {a};
  \node(b) at ({90-\pinwheelTheta}:{1/sqrt(5)}) {b};
  \node(c) at ({90-\pinwheelTheta}:{2/sqrt(5)}) {c};

  \node(d) at ($ (a) + (b) $) {d};

  \draw (Q)--(P)--(c)--(d)--(R)--(a)--(Q);

  \draw (Q)--(b)--(c);
  \draw (b)--(a)--(d);
  \draw (a)--(c);

  \node at (1.7, 0.075) {$\alpha$};
  \end{tikzpicture}
{% endtikz %}

### Equation

$$
\begin{align}
    a &= P + \frac{PR}{2} &
    b &= \text{polar}\left(\frac{1}{\sqrt 5}\left|QP\right|,\ \text{phase}(QP) - \alpha\right)\\
    c &= \text{polar}\left(\frac{2}{\sqrt 5}\left|QP\right|,\ \text{phase}(QP) - \alpha\right) &
    d &= \text{polar}\left(\frac{2}{\sqrt 5}\left|Ra\right|,\ \text{phase}(Ra) - \alpha, \right)
\end{align}
$$

In the case of tiles which have been mirrored the signage of _alpha_ is simply reversed. As
mentioned above this sign is easily obtained by crossing the vectors resulting from the _thumb_ and
_index_ vertices in relation to the _origin_. After that it is just a simple case of writing
iteratively subdividing

Sphinx Rep-Tile
---------------

### Diagram

{% tikz sphinx-diagram %}
  \begin{tikzpicture}[scale=4]
  \newcommand{\phase}[1]{\text{phase}\left(#1\right)}
  \newcommand{\polar}[1]{\text{polar}\left(#1\right)}
  \newcommand{\abs}[1]{\left|#1\right|}

  \newcommand{\QR}{QR}
  \newcommand{\QP}{QP}

  \node(Q) at (0, 0) {Q};
  \node(P) at (1, {sqrt(3)}) {P};
  \node(a) at (1.5, {sqrt(3)/2}) {a};
  \node(b) at (2.5, {sqrt(3)/2}) {b};
  \node(R) at (3, 0) {R};

  \node(j) at (0.5, 0) {j};
  \node(e) at (1.5, 0) {e};
  \node(k) at (2.5, 0) {k};

  \node(h) at (0.25, {sqrt(3)/4}) {h};
  \node(i) at (0.50, {sqrt(3)/2}) {i};

  \node(f) at ({0.5 + 0.50}, {sqrt(3)/2}) {f};
  \node(g) at ({0.5 + 0.25}, {sqrt(3)/4}) {g};

  \node(c) at ({1.5 + 0.70}, {sqrt(3)/4}) {c};
  \node(d) at ({1.5 + 0.25}, {sqrt(3)/4}) {d};

  \draw (Q)--(h)--(i)--(P)--(a)--(b)--(R)--(k)--(e)--(j)--(Q);
  \draw (h)--(g)--(f)--(a);
  \draw (b)--(c)--(d)--(e);
  \draw (f)--(e);
  \end{tikzpicture}
{% endtikz %}

### Equation

This set of equations benefits greatly from establish a more natural basis to describe points in

$$
\newcommand{\QR}{QR}
\newcommand{\QP}{QP}
\newcommand{\Qh}{Qh}
\newcommand{\Qj}{Qj}
\begin{align}
  \Qh &= \frac{1}{4}\QP \\
  \Qj &= \frac{1}{6}\QR
\end{align}
$$

in this bases all points fall nicely on a Cartesian grid

$$
\begin{align}
  h &= Q + \Qh  & j &= Q + \Qj  & f &= h + \Qj  & a &= i + 2\Qj \\
  i &= Q + 2\Qh & e &= Q + 3\Qj & g &= i + \Qj  & d &= h + 3\Qj \\
    &           & k &= Q + 5\Qj & b &= h + 4\Qj &   &           \\
    &           &   &           & c &= i + 4\Qj &   &           \\
\end{align}
$$

We can then write all of the coordinates in polar form using the _origin_ as our reference point.


Iterate!
--------

After defining the position of coordinates, handling chirality and establishing an origin point,
all that's left is to continually iteratle our rep-tiles and keep track of all the re-ptiles we
have created

```python
for _ in range(iterations - 1):
    new_rep_tiles = []
    for rep_tile in rep_tiles:
        new_rep_tiles += rep_tile.subdivide()
    rep_tiles = new_rep_tiles
```

and then render the end result! For additional prettiness the phase of a key edge is assigned a
colour to help aid in distinguishing sub-tiles after subdivision. It was found to be a surprisingly
non-trivial to define a way to colour triangles well due to the chirality of the problem.
Nonetheless a simple method was implemented that is self-consistent if not ideal and can be easily
overwritten in the future if anyone else has a better colouring scheme. The results are simply
gorgeous.

### Pinwheel Rep-Tile
![Image of pinwheel rep-tile](../images/rep-tiles/pinwheel.png)

### Sphinx Rep-Tile
![Image of sphinx rep-tile](../images/rep-tiles/sphinx.png)
