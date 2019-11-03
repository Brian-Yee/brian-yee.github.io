---
title:  Let's Write an MCMC Sudoku Solver Part II/III
date:   2019-10-23 00:00:00
layout: default
categories: [""]
author: Brian Yee
---

**Full code to tinker and play with is available on [GitHub]()**


Recap
=====

In the [previous post]() of this series we created a brute-force algorithm to find a solution to a
sudoku puzzle. In doing so outlined some key definitions including the rules of sudoku and the data
structures that we adopted to express these rules. A summary of variables is outlined below using
the following image of a sudoku will provide us a reference as a working example

<p style="text-align:center">
    <a href="https://en.wikipedia.org/wiki/Sudoku_solving_algorithms#/media/File:Sudoku_Puzzle_by_L2G-20050714_standardized_layout.svg">
        <img alt="An example of a typical sudoku from Wikipedia" src="../images/sudoku/typical-sudoku.png">
    </a>
</p>

Sudoku
------

A nine by nine grid constructed with values from 1-9 which when solved obey the following
properties.

1. No number is duplicated row-wise
2. No number is duplicated column-wise
3. No number is duplicated within a uniform 3x3 grid overlay of the 9x9 grid

The corresponding data-structure of the initial state of the given solved sudoku instance is of an
array form with `0`s indicating not given initial number and `1-9` values indicating initially
given values we express our working example in the following form

```
5 3 0  0 7 0  0 0 0
6 0 0  1 9 5  0 0 0
0 9 8  0 0 0  0 6 0

8 0 0  0 8 0  0 0 3
4 0 0  2 0 6  0 0 1
7 0 0  0 3 0  0 0 6

0 6 0  0 0 0  2 8 0
0 0 0  4 1 9  0 0 5
0 0 0  0 8 0  0 7 9
```

Blocks
------

Coordinates of the blocks that subdivide the sudoku grid. The data structure is of the form of a
list of x-values and y-values that constitute each block. In our working example

```
(
    ((0, 1, 2, 0, 1, 2, 0, 1, 2), (0, 0, 0, 1, 1, 1, 2, 2, 2)),
    ((3, 4, 5, 3, 4, 5, 3, 4, 5), (0, 0, 0, 1, 1, 1, 2, 2, 2)),
    ((6, 7, 8, 6, 7, 8, 6, 7, 8), (0, 0, 0, 1, 1, 1, 2, 2, 2)),
    ...
    ((6, 7, 8, 6, 7, 8, 6, 7, 8), (6, 6, 6, 7, 7, 7, 8, 8, 8)),
)
```

Pinned
------

Coordinates of values which are given initially and are thus immutable (unchangeable). In the
reference image these are the numbers on the grid. The data structure is the same as the `blocks`
variable. For example. In our working example

```
(
    ((0, 1, 0, 1, 2), (0, 0, 1, 2, 2)),
    ((4, 3, 4, 5), (0, 1, 1, 1)),
    ((7), (2)),
    ...
    ((6, 7, 8, 7, 8), (6, 6, 7, 8, 8)),
)
```

Free
----

Coordinates of values which are given initially and are thus mutable (changeable). In the reference
image these are the empty cells on the grid. The data structure is the same as the `blocks`
variable. For example. In our working example

```
(
    ((2, 1, 2, 0), (0, 1, 1, 2)),
    ((3, 5, 3, 4, 5), (0, 1, 1, 1)),
    ((7), (2)),
    ...
    ((8, 6, 7, 6), (6, 7, 7, 8)),
)
```

Allowed
-------

The possible values a cell is allowed when regarding the rule that no duplicates may exist in
cells. The data structure is simply a list of these potential values. In our working example

```
(
    (1, 2, 4, 7),
    (2, 3, 4, 6, 8),
    (1, 2, 3, 4, 5, 7, 8, 9),
    ...
    (1, 3, 4, 6),
)
```

Crosses
-------

The horizontal and vertical lines which intersect at the coordinate of a given cell. For example
the cross of cell `o` has coordinate values of cells denoted by 'x'

```
_ _ _ _ _ x _ _ _
_ _ _ _ _ x _ _ _
_ _ _ _ _ x _ _ _
x x x x x o x x x
_ _ _ _ _ x _ _ _
_ _ _ _ _ x _ _ _
_ _ _ _ _ x _ _ _
_ _ _ _ _ x _ _ _
_ _ _ _ _ x _ _ _
```

The data structure is the same as `blocks`

Markov Chain Monte Carlo (MCMC)
===============================

At it's core MCMC is a way to traverse a set of states efficiently. The way we traverse states is
where the "Markov Chain" part comes from and the efficiently part is where "Monte Carlo" comes
from. We shall expand on each seperately

Monte Carlo
-----------

Everyone knows that

$$
\pi = 3.14159265358979...
$$

but if civilization collapsed and you needed to calculate it using only sticks and stones how would
you go about doing it without a computer? While this may appear to be a contrived example the
restriction to form methods to calculate something easy as \\(\pi\\) (pun intended) without a
computer can help us grasp techniques that can calculate things much more complicated then \\(pi\\)
with the aid of a computer.

One way perhaps would be to calculate the area of a circle and divide it by the area of a
circumscribing square since

$$
\frac{\text{Area of Circle}}{\text{Area of Square}} = \frac{\pi r^2}{(2r)^2} = \frac{\pi}{4}
$$

Now we seek an _imperative_ way of calculating this ratio. One way would be to approximate the area
of each by overlaying a grid on top and counting the squares that fall within each. If we took this
approach we would expect higher resolution of this overlaying grid to yield higher accuracy of our
approximation of \\(pi\\). This begs the question if the case of an infinite resolution is
possible.

Suppose we had an infinitely fine grid laid over the circle and square. If we began counting from
the bottom left corner to the bottom right corner and then move up to the next infinitesimally
small row we would never have our approximation because... well by definition infinities are not
finitely countable! So we will mix up the order of our counting, randomly selecting an
infinitesimally small square to tally of whether or not it was in the circle or in the square. If
this feels familiar to you it is because it is. We are simply _sampling_ from a _uniform_
distribution to calculate the approximate areas of both shapes and our "infinitesimally small
cells" on the grid are just points in the real number domain. The longer we sample the more
accurate we become because the more of our infinitesimal grid we have counted. Visually let us look
at this random sampling often framed as "throwing darts" at a board with the outlines on them

<p style="text-align:center">
example of monte carlo from wikipedia
</p>

As we see, the random sampling of the uniform distribution of the domain set out by the radius
squared can be used to approximate \\(\pi\\) by the set of points that fall within the arc.

![](Meseeks stickler)

Now some of you may complain that this was putting the cart before the horse. We had to know
\\(pi\\) to draw the arc, very well, that is a fair point. It is not unreasonable to expect that we
merely _recovered_ pi for this simulation as opposed to approximated it. Consider the function that
determines the boundary of the arc a black box however and we have _extracted_ \\(\pi\\) from it.
However there is no reason why we couldn't test if the _distance to the origin_ is less than the
radius we are sampling from within in our domain. Now we have removed the concept of the arc for an
indicator function 

$$
f(q) \mathbb{I}\left(\sqrt{q_x^2 + q_y^2} < r)\right)
$$

In this way we have avoided writing or inadvertently using \\(pi\\) at any point in our simulation.
Furthermore, it helps us to see that often times the _declarative_ understanding of a problem can
be expressed as an indicator or logical function that can be used _imperatively_ to approximate a
value. This ability is what make the marriage between Monte Carlo and Markov Chains so beautiful
and powerful.

Markov Chains
-------------
