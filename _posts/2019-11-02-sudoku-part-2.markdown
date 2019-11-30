---
title:  Let's Write an MCMC Sudoku Solver Part II/III
date:   2019-11-04 00:00:00
layout: default
categories: [""]
author: Brian Yee
---

**Full code to tinker and play with is available on [GitHub](https://github.com/Brian-Yee/montecarlo-sudoku)**

**This is part 2 of the series. Check out [Part 1 Here](sudoku-part-1)!**

Recap
=====

In the [previous post](sudoku-part-1) of this series we created a brute-force algorithm to find a solution to a
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
from. We shall expand on each separately

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
    <img alt="Calculating pi using MCMC" src="../images/sudoku/pi-mcmc.gif">
</p>

As we see, the random sampling of the uniform distribution of the domain set out by the radius
squared can be used to approximate \\(\pi\\) by the set of points that fall within the arc. Now
some of you may complain that this was putting the cart before the horse. We had to know \\(pi\\)
to draw the arc, very well, that is a fair point. It is not unreasonable to expect that we merely
_recovered_ pi for this simulation as opposed to approximated it. Consider the function that
determines the boundary of the arc a black box however and we have _extracted_ \\(\pi\\) from it.
However there is no reason why we couldn't test if the _distance to the origin_ is less than the
radius we are sampling from within in our domain. Now we have removed the concept of the arc for an
indicator function

$$
f(q) = \mathbb{I}\left(\sqrt{q_x^2 + q_y^2} < r\right)
$$

In this way we have avoided writing or inadvertently using \\(\pi\\) at any point in our simulation.
Furthermore, it helps us to see that often times the _declarative_ understanding of a problem can
be expressed as an indicator or logical function that can be used _imperatively_ to approximate a
value. This ability is what make the marriage between Monte Carlo and Markov chains so beautiful
and powerful.

Markov Chains
-------------

To explain Markov chains I rely on the excellent post on visualizing Markov chains by
[setosa.io](http://setosa.io/blog/2014/07/26/markov-chains/).  For the reader who wishes to
learn more about Markov chains I highly recommend reading the blog post in full. However, for the
purpose of explaining MCMC at a level sophisticated enough to implement it for Sudoku the following
animation of a simple two-state Markov system should be sufficient.

<iframe scrolling="no" style="display: block; float: left; border: none;"
src="http://setosa.io/markov/transition-matrix.html#%7B%22tm%22%3A%5B%5B0.5%2C0.5%5D%2C%5B0.5%2C0.5%5D%5D%7D"
width="100%" height="330"></iframe>

As one can see there is a little orb that traverses around on arrows and lands in a large blue or
orange node. These nodes are the _states_ of the system and the gray orb indicates the _current
state_ of the system. Markov systems are iterative so we define the term _transition_ as the gray
dot taking any arrow and falling into its corresponding state. The arrows indicate the possible
ways into or out of a state. The width of the arrows, the respective probabilities that given you
are in a state you will follow an arrow. Mathematically this is written as

$$
\text{probability} (\text{take arrow given you are in a state}) = p (\text{take arrow} | \text{state})
$$

The arrows themselves however are not important, _the states the arrows bring you to_ is what we are
concerned about. Thus we write our probability function not as the probability of transition into a
state given the current state you are in

$$
p (\text{take arrow} | \text{state}) = p (\text{next state} | \text{state})
$$

For our simple illustrative two-state Markov system all _transitions_ can be easily enumerated and
organized into a _transition matrix_

$$
P = \begin{pmatrix}
p (a | a) & p (b | a)\\
p (a | b) & p (b | b)
\end{pmatrix}
$$

Here the columns represent the probability of _going into_ a specific state while the rows indicate
the probabilities _available from_ from a specific state. At every step of the Markov process we
find our selves in some state (in this case \\(a\\) or \\(b\\)) and thus when we express all our
options of leaving from that state, we must ensure that the probabilities are normalized<sup>1</sup>.

$$
P = \begin{pmatrix}
1 \\
1
\end{pmatrix}
$$

With our formalization we can now answer questions like given some observed state $x$ what are the
most likely states to be observed next?

$$
x_{i+1} = Px_i
$$

Astute readers of this blog may note the self-recurrence notation previously employed in the post
about [Chaos Theory](bifurication) and realize that we can identify the _steady state_, by
substituting the equation into itself

$$
\begin{align}
x_{i+1} &= Px_i\\
x_{i+2} &= Px_{i+1} = PPx_i\\
\hphantom{Px_{i+2} = PPx_{i+1} = PPPx_i} x_{i+3} &= Px_{i+2} = PPx_{i+1} = PPPx_i\\
& \vdots\\
\lim_{j \rightarrow \infty} x_j &= \lim_{j \rightarrow \infty} P^j
\end{align}
$$

This steady-state solution is be extremely useful. For example, the [PageRank
algorithm](https://en.wikipedia.org/wiki/PageRank) originally used by google calculated an
approximation of the steady-state solution of the Internet for a person randomly surfing the web.
Often the difficult part is finding efficient ways of calculating this matrix. There are various
[distributed computing techniques](https://arxiv.org/abs/1208.3071) to minimize reads or [sparse
matrix
approximations](https://profs.info.uaic.ro/~ancai/CN/bibliografie/DelCorso%20efficient%20pagerank%20computation.pdf)
to be made or perhaps as you may of guessed to this point Monte Carlo algorithms to help calculate
states of interest.

Putting it Together: MCMC Sudoku
===============================

You are now as possibly equipped as you could be given five minutes of study to understand the
popular MCMC technique called the Metropolis-Hasting's Algorithm. For the dedicated readers I will
refer you to [Newmann and Barkema's
derivation](https://global.oup.com/academic/product/monte-carlo-methods-in-statistical-physics-9780198517979?cc=ca&lang=en&).
Metropolis hastings at it's core is very similar to the reinforcement learning concept of explore
exploit. We will take a series of iterative steps where we submit a _trial_ state of which two
possible outcomes are available

- Exploit: If a trial-state brings us closer to the solution-state: always take it.
- Explore: If a trial-state does not bring us closer to the solution-state: give it a chance.

To define what "_closer to the solution-state_" means we will associate an _energy function_
to describe the _energy_ of our system. The _lowest possible energy of our system_ has a state
correspondingly called the _ground state_. We wish to construct this energy function such that the
solved sudoku system is equivalent to the ground state. We begin by expressing the energy of our
system as the sum of all energies contributed by a sudoku cell of the system

$$
E_{total} = \sum_{i=1}^9 \sum_{j=1}^9 e(i, j)
$$

Next we define our energy function per cell as the number of duplicates it shares across rows,
columns and within its corresponding block

$$
e(i, j) = \text{duplicates-in-row} + \text{duplicates-in-column} + \text{duplicates-in-block}
$$

we now note that we can constrain one of these terms to \\(0\\) by initially populating our board
in such a way that our initial configuration is obeyed and constraining our system to always obey
this. For symmetry we will initially populate and constrain our sudoku array block wise. With this
constraint it is now easy to consider a way to build a trial state for each iteration. Simply take
two free cells at random within a block and try to swap them! Furthermore, why use duplicates?

We are now almost complete, but the last bit of Metropolis sauce is to choose how, given we are in
an explore mode to "_give [the trial state] a chance_". In short it is done by taking inspiration
from physics (as with all the naming convention up to this point) and use the Boltzmann
Distribution given by

$$
P(\text{trial} | \text{current}) = \text{exp}\left(\frac{- \Delta E}{k T}\right)
$$

where \\(\Delta E\\) is the difference in energy between your trial state and current state, \\(T\\)
is a tunable parameter and \\(k\\) is another tunable parameter and the universe is very happy if
you set it to a constant denoted \\(k_B\\) for Boltzmann's Constant because it makes the tunable
parameter \\(T\\) equal to temperature in the units of Kelvin degree. However, for physics
application we can simply ignore \\(k\\) and scale our temperature parameter to play nicely with
the difference in energy.

Implementation
==============

Holy-moly this has been a lot of theory! If you've made it this far, kudos to you, now you get that
sweet sweet applied pay out. We begin by creating three functions

| Function           | Purpose                                                       |
|--------------------|---------------------------------------------------------------|
| `new_swap_pair`    | Generate two cells within the same block to form a trial pair |
| `swap_energy_diff` | Calculate the energy difference if a trial pair is swapped    |
| `energy`           | Calculate the total energy of the sudoku array                |

Out of these functions only `swap_energy_diff` requires a bit more insight. While the path of least
resistance entails simply calculating the total energy of one state and subtracting it from the
other under a little inspection it is straightforward to observe that for a trial pair formed of
cells denoted as `A` and `B` the only change in difference can come from the energy arising from
the cross of each formed by the intersecting row and column they belong too. Visually,

```
+---------+---------+---------+            +---------+---------+---------+
| .  .  . | .  .  . | .  .  . |            | .  .  . | a  .  b | .  .  . |
| .  .  . | .  .  . | .  .  . |            | .  .  . | a  .  b | .  .  . |
| .  .  . | .  .  . | .  .  . |            | .  .  . | a  .  b | .  .  . |
+---------+---------+---------+            +---------+---------+---------+
| .  .  . | .  .  . | .  .  . |            | .  .  . | a  .  b | .  .  . |
| .  .  . | A  .  . | .  .  . |     ->     | a  a  a | A  a  * | a  a  a |
| .  .  . | .  .  B | .  .  . |            | b  b  b | *  b  B | b  b  b |
+---------+---------+---------+            +---------+---------+---------+
| .  .  . | .  .  . | .  .  . |            | .  .  . | a  .  b | .  .  . |
| .  .  . | .  .  . | .  .  . |            | .  .  . | a  .  b | .  .  . |
| .  .  . | .  .  . | .  .  . |            | .  .  . | a  .  b | .  .  . |
+---------+---------+---------+            +---------+---------+---------+
```

where `a`/`b` correspond to the rows/columns corresponding to `A`/`B` and `*` corresponds to a cell
belonging to each. With our prior formulation this difference in energy can be calculated as

$$
\Delta E = e\left(b_i, b_j\right) - e\left(a_i, a_j\right)
$$

where the subscripts denote the sudoku array coordinates corresponding to each sudoku cell. With
our functions defined we can write our psuedo-code

```
populate the board usch that all values in a block are unique

calculate the initial energy

while the ground state has not been reached
    generate a trial pair
    calculate the energy difference

    if energy difference is less zero:
        accept and update system
    else if the value of the energy in the boltzmann distribution is greater than some random uniform values
        accept and update the system
```

And because Python is basically psuedo-code the implementation is only a few more lines

```
def mcmc_simple(sudoku, indexer, temp=0.25):
    """
    Solve sudoku system with backtracking algorithm.

    Arguments:
        sudoku: np.array
            A sudoku puzzle, 0/-1 indicate empty and forbideen cells respectively.
        indexer: src.indexer.Indexer
            Essential indices for manipulating a Sudoku system.
        temp:
            Temperature parameter for introducing thermal disorder. Hand tuned value of
            0.3 seems to yield good results

    Returns:
        sudoku: np.array
            A solved sudoku puzzle.
    """
    for free, allowed in zip(indexer.free, indexer.allowed):
        sudoku[free] = allowed

    energy = _energy(sudoku, indexer)

    while energy != 0:
        trial_swap = new_swap_pair(indexer.free)
        energy_diff = swap_energy_diff(sudoku, trial_swap, indexer)
        if energy_diff <= 0 or np.exp(-energy_diff / temp) > random.random():
            sudoku[trial_swap] = sudoku[trial_swap][::-1]
            energy += energy_diff

    return sudoku
```

Simulation
==========

To demonstrate the behaviour of the system as it converges to a solution I have recorded a
screencast where I run it multiple time and every 100 iterations print out the sudoku board to
screen. The values are printed out and if the row or column contains a duplicate a `*` is appended
immediately following the values of the cells in the respective row or column.

<p style="text-align:center">
    <img alt="Gif of multiple restarts of a metropolis hastings simulation of a sudoku board" src="../images/sudoku/mcmc-sudoku-terminal.gif">
</p>

We can observe that unlike our previous [backtracking algorithm](sudoku-part-1) every run
of the program takes a random configuration to the path. While this may seem inefficient for small
sudoku systems. They help us to solve generalized sudoku systems that have a space that is too
large to be made tractable by the backtracking algorithm. Generalized sudoku systems interlock
blocks which when solved continue to obey the sudoku rules for each sub-sudoku system. Note that we
never relied on slicing our arrays to define the relations of sets and rows, they were simply
coordinates initialized at the beginning of our program. Thus the only additional step required to
generalize sudoku is that of I/O reading in larger sudoku problems and generating the respective
crosses and blocks for every cell.

For example below is a Samurai Sudoku published by the Washington Post on 2018-10-14. The
temperature parameter of the simple MCMC was quickly tuned by hand to `0.25` which corresponded to
finding a solution in `74.66s`. Simple backtracking tested for up to `3` minutes (because aint no
body got time for that) fails to identify the solution illustrating the benefits of using
stochastic state space search over exhaustive methods.

```
. 7 . 8 . 9 . 4 .       . 1 . 6 . 7 . 8 .        3 7 1 8 2 9 6 4 5       5 1 3 6 4 7 2 8 9
. . . 6 . 1 . . .       . . . 2 . 9 . . .        4 5 9 6 7 1 8 3 2       6 7 4 2 8 9 3 1 5
. . 8 . 4 . 1 . .       . . 2 . 5 . 4 . .        6 2 8 3 4 5 1 7 9       9 8 2 3 5 1 4 6 7
7 8 . . . . . 6 3       2 3 . . . . . 7 6        7 8 2 9 1 4 5 6 3       2 3 5 1 9 4 8 7 6
1 . . 5 8 7 . . 4       7 . . 5 6 8 . . 3        1 3 6 5 8 7 2 9 4       7 4 1 5 6 8 9 2 3
5 9 . . . . . 1 8       8 9 . . . . . 5 4        5 9 4 2 3 6 7 1 8       8 9 6 7 2 3 1 5 4
. . 5 . 6 . . . . 2 . 5 . . . . 3 . 7 . .        9 4 5 1 6 2 3 8 7 2 4 5 1 6 9 8 3 5 7 4 2
. . . 7 . 8 . . . 8 . 9 . . . 4 . 6 . . .        2 1 3 7 9 8 4 5 6 8 1 9 3 2 7 4 1 6 5 9 8
. 6 . 4 . 3 . . . . 6 . . . . 9 . 2 . 3 .        8 6 7 4 5 3 9 2 1 3 6 7 4 5 8 9 7 2 6 3 1
            5 7 . . . . . 1 4                                5 7 3 9 2 6 8 1 4
            1 . . 7 5 8 . . 2                                1 4 9 7 5 8 6 3 2
            2 6 . . . . . 7 5                                2 6 8 4 3 1 9 7 5
. 5 . 1 . 3 . . . . 7 . . . . 1 . 6 . 2 .        7 5 8 1 2 3 6 9 4 1 7 2 5 8 3 1 4 6 7 2 9
. . . 4 . 8 . . . 6 . 4 . . . 3 . 7 . . .        9 2 1 4 6 8 7 3 5 6 8 4 2 9 1 3 5 7 4 6 8
. . 6 . 7 . . . . 5 . 3 . . . . 2 . 1 . .        3 4 6 5 7 9 8 1 2 5 9 3 7 4 6 8 2 9 1 3 5
1 6 . . . . . 4 9       3 5 . . . . . 9 4        1 6 3 7 8 2 5 4 9       3 5 8 7 6 1 2 9 4
2 . . 3 9 4 . . 8       1 . . 5 3 4 . . 7        2 7 5 3 9 4 1 6 8       1 2 9 5 3 4 6 8 7
4 8 . . . . . 7 3       4 6 . . . . . 5 1        4 8 9 6 5 1 2 7 3       4 6 7 9 8 2 3 5 1
. . 4 . 3 . 9 . .       . . 4 . 9 . 8 . .        5 1 4 8 3 6 9 2 7       6 1 4 2 9 5 8 7 3
. . . 2 . 5 . . .       . . . 6 . 3 . . .        6 9 7 2 4 5 3 8 1       8 7 5 6 1 3 9 4 2
. 3 . 9 . 7 . 5 .       . 3 . 4 . 8 . 1 .        8 3 2 9 1 7 4 5 6       9 3 2 4 7 8 5 1 6
```

Summary & Next Part
===================

We reviewed the data-structures originally outlined in the [previous post](sudoku-part-1) in
preparation for using them to solve a sudoku system using a Markov Chain Monte Carlo method. Both
Markov chains and Monte Carlo methods were motivated and how they can be combined at a surface
level to form the Metropolis Hastings Algorithm. We frame the sudoku problem in terms of a system
that can be minimized by the Metropolis Hastings Algorithm and observed the behaviour of the system
as it converged to a solution. Our work was rewarded by combining all that we've learned to solve a
Samurai Sudoku system (five interlocked sudokus).

Where to go from here? In the next post, we will use the learned lessons from the backtracking
algorithm as well as the concept of MCMC to create an even more powerful technique known as a Monte
Carlo Tree Search (MCTS). MCTS has been found to be highly effective in the discipline of
Reinforcement Learning, especially so when it was used in combination with neural networks to
create [AlphaGo](https://en.wikipedia.org/wiki/AlphaGo) the first program to beat humans in a game
with a mind-bogglingly large state space. We will not be solving anything nearly so sophisticated
but we will work through an illustrative example to help us learn more about the technique.

Footnotes
=========

<sup>1</sup> for readers unfamiliar or rusty with Linear Algebra notation this is equivalent to

$$
\begin{align}
p(a | a) + p(b | a) &= 1\\
p(a | b) + p(b | b) &= 1
\end{align}
$$
