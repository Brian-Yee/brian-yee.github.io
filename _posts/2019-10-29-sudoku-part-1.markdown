---
title:  Let's Write an MCMC Sudoku Solver Part I/III
date:   2019-11-03 00:00:00
layout: default
categories: [""]
author: Brian Yee
---

**Full code to tinker and play with is available on
[GitHub](https://github.com/Brian-Yee/montecarlo-sudoku)**

**This is part 1 of the series. Check out [Part 2 Here](sudoku-part-2)!**

Background
==========

This is a tutorial to teach you how to write a Markov Chain Monte Carlo (MCMC) sudoku solver while
ideally understanding what the hell is going on. MCMC is a powerful statistical technique employed
in many fields and more importantly an important concept for any statistician and thereby one might
controversially claim machine learning practitioner or even data scientist. This will be part of a
series on building a MCMC application that can solve arbitrary sudoku puzzles. Part I will deal
with defining the problem and writing a brute-force algorithm. Part II will expand upon the
familiarity built to introduce a more efficient _stochastic_ method that overcomes the short
comings of the brute-force approach. Finally Part III will take the concepts of the MCMC
application we wrote and discuss it's implications in Monte Carlo Tree Search which falls within
the same conceptual category as our application.

Problem Definition
==================

A sudoku is a brain puzzle that requires constructing a 9x9 grid of numbers such that

1. No number is duplicated row-wise
2. No number is duplicated column-wise
3. No number is duplicated within a uniform 3x3 grid overlay of the 9x9 grid

An example of a solved sudoku is given below:

<p style="text-align:center">
    <a href="https://en.wikipedia.org/wiki/Sudoku_solving_algorithms#/media/File:Sudoku_Puzzle_by_L2G-20050714_standardized_layout.svg">
        <img alt="An example of a typical sudoku from Wikipedia" src="../images/sudoku/typical-sudoku.png">
    </a>
</p>

To solve a sudoku the sudoku crafter presents a set of cells already filled in with numbers such
that the solver can deduce _deterministically_ what _unique_ solution exists that contains the
provided cells. For example, the solved sudoku above can be deduced from the presented sudoku below
with the original values written in orange and the deduced values written in blue.

<p style="text-align:center">
    <img alt="An example of a solved typical sudoku from Wikipedia" src="../images/sudoku/solved-typical-sudoku.png">
</p>

Lets Write some "A.I."
======================

I hate the initialism "AI". It encompasses what I feel is the last straw before the bubble strains
to support the claims that have been made to this point and lead to the next
[winter](https://en.wikipedia.org/wiki/AI_winter). In fact at the Deep Learning Summit I
specifically asked a group of panelists there opinions about government regulation in the case of a
next winter and was met with an interesting milleu with one of the panelists firmly dismissing the
possibility of it ever happening again. However, putting aside my personal gripes with hype-cycles
and branding I think it is fair to say that the majority of people today would be receptive to a
definition of "AI" that included being able to solve a sudoku or perhaps more broadly any computer
system they can play games with such as: Tic-Tac-Toe, Chess, Connect 4, Gomoku, Reversi, Go, etc.
The difference between Sudoku and all the previously listed games is that sudoku is a 1-player
game, it is a puzzle, it does not require the idea of an adversarial (or cooperative agent). This
makes it particularly attractive to solving as we do not have to encode the idea of how someone
might try to make the system fail during game-play.

Given we have the safety of avoiding someone trying to make our program fail, we can start by
implementing a very simple solution. We know that there exists some set of rules which must be
satisfied to "win" the 1-player game. Why not then simply just enumerate over all possibilities and
check which configurations satisfy the rules? The immediate answer should be obvious that there are
so many game states that this would require an extraordinary amount of compute power. However,
there exists a class of algorithms under the umbrella of [Dynamic
Programming](https://en.wikipedia.org/wiki/Dynamic_programming) aimed to circumvent this explosion
and make problems tractable by reducing a problem into a series of sub-problems. We will take
inspiration from dynamic programming to reduce potentialy redundant calculations to make our first
"AI" which "_intelligently_" enumerates over the space of possible grid values to identify the
valid one.

The BackTracking Algorithm
==========================

We know for a valid sudoku solution no rule can be violated at any time. Thus a board that can be
constructed around an invalid subset need not be searched. For example, if one row has duplicate
values in it, all other values in the grid are irrelevant, none can "undo" the invalidity caused by
the one row with duplicates. Our goal is to construct an algorithm to leverage this seemingly
obvious fact to make our problem tractable.

To do this let us visualize a sudoku in an "unrolled" version where it is a one-dimensional
traversal of the board as a data structure. We can now view the previous spatial relations simply
as a set of connections that adhere to the specified rules. If we start at the end of this data
structure and submit a trial value we can check to see if it satisfies all of it's rules imposed on
it via it's connections. We then perform the 3 following actions based on some intuitive logic

1. If all rules are satisfied we have a _candidate cell value_ and can try finding another
candidate cell value for the next number
2. If it does _not_ satisfy all the rules we can try a new value within the same cell
3. If none of the possible value from 0-9 satisfy the cell then we know the _previous_ cell must
have a wrong value so we free up the enumerated cell and try a new trial value than previously.

We know that all cells and therefore the first cell we try as well have the limited set of values
from 0-9, _one of which_ must be part of a subset of the solution. Thus we now have a way to
enumerate over all states while avoiding the exploration of redundant computations. A visualization
of the backtracking algorithm is given here.

<p style="text-align:center">
    <img alt="Gif of Backtracking Algorithm" src="../images/sudoku/backtracking.gif">
</p>

It should be noted that while we were guaranteed to find a solution the amount of time required to
find the solution is still not guaranteed to be reasonable. Still never the less the backtracking
algorithm works surprisingly well for it's level of sophistication and intuitive logic.

Implementation
==============

Data Structures
---------------

Now that we have gained a conceptual understanding of the backtracking algorithm all that is left
is to define the _procedure_ in which to compute it, i.e. it's implementation. While we initially
discussed a 1D data structure with relations it is easier to consider only the free cells in which
we can modify the values as part of the "unrolled" sudoku version and submit them to the sudoku
grid to evaluate their validity. To do this we need a way of expressing a sudoku board to the
computer. We shall use `0` to indicate a free cell and `1-9` respectively to represent the
potential values that can be put in a sudoku grid. Using this representation the sudoku mentioned
in the prior section is encoded as

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

where I have added white space illustratively. A little foresight here we aid us
in our development of the problem. We know that eventually there are 3 rules our
solution will adhere too. Two of these, requiring that no column or row shall
contain duplicates, are easily expressed in our 2D array. The rule of no
duplicate occurring in a 3x3 grid uniform grid overlay is a bit more
complicated. The spatial representation of these _blocks_ that construct the 3x3
grid is irrelevant so we will express these blocks as a `tuple` of length 9
containing all cells.

```
(
    ((0, 0), (1, 0), (2, 0), (0, 1), (1, 1), (2, 1), (0, 2), (1, 2), (2, 2)),
    ((3, 0), (4, 0), (5, 0), (3, 1), (4, 1), (5, 1), (3, 2), (4, 2), (5, 2)),
    ((6, 0), (7, 0), (8, 0), (6, 1), (7, 1), (8, 1), (6, 2), (7, 2), (8, 2)),
    ...
    ((6, 6), (7, 6), (8, 6), (6, 7), (7, 7), (8, 7), (6, 8), (7, 8), (8, 8)),
)
```

furthermore because we will be using `numpy` to efficiently store our arrays we will actually be
expressing this list of coordinates in its transpose form as group x-coords and y-coords together:

```
(
    ((0, 1, 2, 0, 1, 2, 0, 1, 2), (0, 0, 0, 1, 1, 1, 2, 2, 2)),
    ((3, 4, 5, 3, 4, 5, 3, 4, 5), (0, 0, 0, 1, 1, 1, 2, 2, 2)),
    ((6, 7, 8, 6, 7, 8, 6, 7, 8), (0, 0, 0, 1, 1, 1, 2, 2, 2)),
    ...
    ((6, 7, 8, 6, 7, 8, 6, 7, 8), (6, 6, 6, 7, 7, 7, 8, 8, 8)),
)
```

With the ability to now select blocks we will store arrays of free and pinned values within in each
block. This may feel a bit awkward now but it will prove to be an extremely useful data-structure
when we move on to implementing our solution in the form of an MCMC system. We can now define a
function to return the `free` values for us to try modifying and the `pinned` values set at the
beginning of the problem.

```python
def _neighbours(sudoku, blocks):
    """
    Defines neighbours within the same block.

    For example consider the point `o` and corresponding neighbours `x`
        _ _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _ _
        _ _ _ _ _ _ x x x
        _ _ _ _ _ _ x x o
        _ _ _ _ _ _ x x x
        _ _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _ _

    Arguments:
        sudoku: np.array
            A sudoku puzzle, 0/-1 indicate empty and forbideen cells respectively.

    Returns:
        free: tuple(tuple(np.array, np.array))
            Cells within block free to be mutated.
        pinned: tuple(tuple(np.array, np.array))
            Cells within block which were defined at instantiation and thus immutable.
    """
    free, pinned = [], []
    is_free = sudoku == 0
    for block in blocks:
        in_block = np.full_like(sudoku, False)
        in_block[block] = True
        free.append(np.where(is_free & in_block))
        pinned.append(np.where(~is_free & in_block))

    return map(tuple, (free, pinned))
```

leveraging the rule that no duplicates are allowed within the same block to build a set of allowed
values within each block

```python
allowed = [
    [y for y in range(1, 10) if y not in sudoku[pinned]]
    for pinned in pinned
]
```

It is also useful to store the coordinates of the column and row a cell must not duplicate a value
within as a set of static coordinates corresponding to each cell. Given the row and the column form
a "cross" as they intersect we will call this variable `crosses`. These data structures above are
so useful and all related to indexing that we will bind them to an `Indexer` class to conceptually
group them together. This is additionally useful given their data-structures all have a require
elements in each list to be defined in the same order as their corresponding data-structures.

Finally, for our 1D
representation of candidate values we will use two queues<sup>[1]</sup>: one to store the next
possible state and the other to keep track of previously proposed_states. Using our list of
`allowed` values we instantiate a queue of possible states as first element of the `allowed` list.
We then pair that list with it's corresponding coordinate so we can test it on the sudoku board.
When we begin we have no proposed states so that is simply an empty queue.

```python
free_coords = np.hstack(map(np.vstack, indexer.free)).T
next_possible_state = deque((x, 0) for x in free_coords)
proposed_states = deque()
```

With all our effort put into data-structures the procedure of the algorithm will be fairly
straightforward.

Procedure
---------

We have now defined the pre-existing data-structures, vocabulary and concepts required to
communicate the procedure for the back tracking algorithm in psuedo-code

```
while another possible state exists:
    get the coordinate and proposed value of the next state
    get the corresponding allowed values of the block the coordinate belongs to

    if none of the allowed values worked:
        reset this cell
        go back and try the next allowed value in the previous cell
    else if the cell is not a candidate value:
        stay on this cell but try the next allowed value
    else:
        set the value in the sudoku board and try the next possible state
```

and because Python is pretty much psuedo code our implementation does not end up being much more
longer than what was written above.

```python
def backtrack(sudoku, indexer):
    """
    Solve sudoku system with backtracking algorithm.

    Arguments:
        sudoku: np.array
            A sudoku puzzle, 0/-1 indicate empty and forbideen cells respectively.
        indexer: src.indexer.Indexer
            Essential indices for manipulating a Sudoku system.

    Returns:
        sudoku: np.array
            A solved sudoku puzzle.
    """
    free_coords = np.hstack(map(np.vstack, indexer.free)).T
    next_possible_state = deque((x, 0) for x in free_coords)
    proposed_states = deque()

    while next_possible_state:
        coord, idx = next_possible_state.pop()
        allowed = indexer.allowed[indexer.cell_to_block[tuple(coord.tolist())]]

        if idx == len(allowed):
            sudoku[coord[0], coord[1]] = 0
            next_possible_state.append((coord, 0))

            if proposed_states:
                coord, idx = proposed_states.pop()
                sudoku[coord[0], coord[1]] = 0
                next_possible_state.append((coord, idx + 1))
        elif any(allowed[idx] in sudoku[slices] for slices in indexer.crosses(*coord)):
            next_possible_state.append((coord, idx + 1))
        else:
            sudoku[coord[0], coord[1]] = allowed[idx]
            proposed_states.append((coord, idx))

    return sudoku
```

Simulation
----------

All that's left is to wrap these functions in a main function and handle the I/O of Sudoku boards
which I will ignore for brevity. Running the program on my potato MacBook Air the solution is found
in less than 1 second, more than adequately fast for generating a solution and furthermore probably
a good first pass for beginner sudoku enthusiasts in the "Easy" section of the book.

```
5 3 4 6 7 8 9 1 2
6 7 2 1 9 5 3 4 8
1 9 8 3 4 2 5 6 7
8 5 9 7 6 1 4 2 3
4 2 6 8 5 3 7 9 1
7 1 3 9 2 4 8 5 6
9 6 1 5 3 7 2 8 4
2 8 7 4 1 9 6 3 5
3 4 5 2 8 6 1 7 9
```

Summary & Next Part
===================

We have written a basic program that can solve some sudoku problems. We achieved this by
brute-forcing the rules and using some dynamic programming like ways to restrict the solution space
searched. This was done by using two queues one which held the next possible state and another
which held the previously tried states up to that point. Elements were respectively popped or
pushed from each stack depending on the element satisfied the rules required for a cell in a sudoku
solution. In doing this we avoiding checking the candidacy of solutions which we knew would contain
at least one error tremendously narrowing down our space. This algorithm was effective enough on
modern hardware to give us a solution in reasonable time for a reasonably easy sudoku.

In constructing the backtracking algorithm we created various data-structures that will be of use
in the next part. Just as we avoided redundant computation here I will avoid redundant definitions
in the next part, focusing mainly on applying the more sophisticated Markov Chain Monte Carlo
method given the data structures that already exist. In this way we will unlock the ability to
solve even more complex sudokus and furthermore extend our application to variants of sudoku such
as twin sudoku or samurai sudoku.

A Final Note
============

We should not underestimate the use of dynamic programming in many modern "AI" applications. While
this solution may feel somewhat contrived indeed, there are often crucial portions of machine
learning algorithms that require dynamic programming constructs to be efficient. The immediate
example that comes to mind is the [Viterbi
Algorithm](https://en.wikipedia.org/wiki/Viterbi_algorithm) used in language models. Another
example that works surprisingly well is the [XY-Cut
Algorithm](https://en.wikipedia.org/wiki/Recursive_X-Y_cut) as a pre-processing step for OCR and
image document processing. Finally, many industrial applications such as the [Guillotine
Algorithm](https://en.wikipedia.org/wiki/Guillotine_problem) or [Rod
Cutting](https://en.wikipedia.org/wiki/Cutting_stock_problem) have immense repercussions for our
economy as they can help us effectively divide up materials effectively to reduce waste. One should
not under-estimate their usefulness in one's problem solving tool box.


Footnotes
---------
<sup>[1]</sup> We will actually be using a deque (double ended queue) as there is a native
implementation of it in Python.
