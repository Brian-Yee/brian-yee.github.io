---
title:  👃 Smells like Teen Statistics
date:   2019-08-29 00:00:00
layout: default
categories: [""]
author: Brian Yee
---

> Fun fact: statistical physics involves no actual statistics

This is a line from the excellent presentation called [So, you think you have a Power Law, Do You?
Well isn't that Special?](
https://web.archive.org/web/20140407112014/http://www.stat.cmu.edu/~cshalizi/2010-10-18-Meetup.pdf
), given by associate professor Cosma Shalizi and author of [Three Toed Sloth](
http://bactra.org/weblog/ )<sup>[1](#meetup)</sup>. I was first introduced to it during my MSc in
Statistical Physics and was well aware enough of its truth that I chuckled when the post-doc
showed me it -- honestly what does an RG integral have to do with an ANOVA or LOESS anyway? Still,
to say that statistical physics involves _no_ actual statistics is a bit harsh and more
tongue-in-cheek than gospel. Certainly there exist physical analogies for the
[mean](https://en.wikipedia.org/wiki/Center_of_mass),
[median](https://statpics.blogspot.com/2009/08/pearl-balanced-median-necklace.html) and
mode<sup>[2](#mode)</sup> . Moments of variance are similar in form to [moments of
inertia](https://en.wikipedia.org/wiki/Variance#Moment_of_inertia) used in classical mechanics and
lets not forget that physicists where the first to come up with the [Dirac Delta
Function](https://en.wikipedia.org/wiki/Dirac_delta_function) and [Monte Carlo
Methods](https://fas.org/sgp/othergov/doe/lanl/pubs/00326866.pdf). Still Shalizi's comment is more
true than it is false; for what it's worth the exposure to writing efficient computational code
that _calculates_ statistics leaves most with an ability to _smell_ statistics rather than do it
robustly. At the very least given whatever my statistical background, last month while reviewing a
PR I was able to smell out a statistical bug that I am here to share with you today.

The Problem Setup
---------------------------------------------------------------------------------------------------

The problem in which this observation arose was comparing the boxplots of flattened values across
pairwise matrices. This works perfectly well for matrices of small dimensions as the quadratic
growth of flattened values remains small. However some of the results lead to matrices of dimension
1000 which when combined with the number of matrices caused an explosion in memory seg-faulting the
code. To resolve this memory issue a quick fix was to take the mean of the flattened pairwise
matrix values and store them in a list for later plotting of the boxplot. Box plots were generated
for three different algorithms and were plotted based on dimensions of the pairwise matrix and used
to compare the distribution of flattened pairwise values.

A quick justification of this can be arrived at by firing up a REPL and trying out a simple use
case

```R
exponential_dist <- rexp(100, 1)
chunked_exponential_dist <- split(exponential_dist, ceiling(seq_along(exp_dist)/10))
```

there create the following vectors

```shellsession
> exponential_dist
  [1] 0.10040845 0.22064268 0.22743227 1.91102811 1.70002832 1.26626212
  [7] 0.70573814 0.36668351 0.06361205 0.55920494 0.31499952 1.71212780
 [13] 0.96644321 0.34782417 2.66671924 0.36942565 0.01541357 0.61578852
 [19] 0.80950096 0.61548145 2.25982532 1.06149564 0.03152377 1.15469943
 [25] 0.11973875 2.30337852 0.08598898 1.44689556 1.60616025 1.63974942
 [31] 0.16538687 0.19834176 2.56341019 0.32793396 0.15255083 0.75570139
 [37] 1.87026232 1.18896606 0.79857988 0.97789520 1.29321396 0.70034503
 [43] 0.33120481 1.45578254 0.46080200 0.38894050 1.39732713 3.41053014
 [49] 1.03320592 0.71323194 0.98549337 0.25492029 0.70201694 0.50083388
 [55] 0.32212375 1.27967158 0.31344918 0.08453044 1.96240580 0.57931538
 [61] 0.94215019 2.35585205 1.19405724 0.38053984 1.45098902 1.74000821
 [67] 2.56735921 1.77286566 0.03952487 2.10620910 0.08345750 0.48501595
 [73] 0.99264807 0.74660457 1.06685885 1.25461467 1.48548523 0.06813765
 [79] 0.70569337 3.77349513 0.12045481 1.00256061 1.00329329 4.07791462
 [85] 0.45163862 0.99200878 0.18073887 0.55633122 2.80461492 0.39645916
 [91] 0.78128522 0.50392884 4.60954608 0.86250035 1.06255385 0.42298675
 [97] 1.51181538 1.56637269 1.55635264 1.04257545

> chunked_exponential_dist
$`1`
 [1] 0.10040845 0.22064268 0.22743227 1.91102811 1.70002832 1.26626212
 [7] 0.70573814 0.36668351 0.06361205 0.55920494

...

$`10`
 [1] 0.7812852 0.5039288 4.6095461 0.8625004 1.0625539 0.4229867 1.5118154
 [8] 1.5663727 1.5563526 1.0425755
```

Where `exponential_dist` is 100 values from an exponential distribution and
`chunked_exponential_dist` is 10 arrays of 10 values sliced from the `exponential_dist` vector. A
quick calculation of the mean of `exponential dist` vs the mean of means from
`chunked_exponential_dist`

```R
> mean(exponential_dist)
[1] 1.051501
> mean(sapply(chunked_exponential_dist, mean))
[1] 1.051501
```

shows each to lead to an equivalent result. So the memory explosion issued was solved and
development continued. **Where did the bug arise?**

Demonstration of Bug
---------------------------------------------------------------------------------------------------

The bug arises from the fact that the results are being stored for a _boxplot of the distribution
of the flattened values_ not the _mean of the distribution of flattened values_. That is to say
that the quick verification that the _mean of means_ preserved the _mean_ of the distribution
tested nothing about the _variance_. Lets try this again but instead of taking the means lets plot
the distribution. Additionally, given we are generating plots and not print outs, I am going to
kick up the number of randomly generated numbers by a factor of `1000` times. I will continue
chunking them into arrays of size 10 (that is the distribution will be divided into `10k` chunks)

```R
exponential_dist <- rexp(1000000, 1)
p1 <- hist(exponential_dist, breaks=99)

chunk_size <- 10
chunks <- split(exp_dist, ceiling(seq_along(exp_dist)/chunk_size))
p2 <- hist(sapply(chunks, mean))

plot(p1, col=rgb(0,0,1,1/4), xlim=c(0,10), ylim=c(0, 1.5), freq=FALSE)
plot(p2, col=rgb(1,0,0,1/4), xlim=c(0,10), ylim=c(0, 1.5), freq=FALSE, add=T)

legend(
    "topright",
    pch = c(15, 15),
    col = c(col=rgb(0,0,1,1/4), rgb(1,0,0,1/4)),
    legend=c("Exponential", "Mean of Means")
)
```

![An plot of mean values sampled from chunk sizes 1, 10](../images/mean-of-means/histogram-comparison.png)

Certainly different! Why exactly did the distribution change? Lets up the chunking size and take
another look

```R
chunk_size <- 100
larger_chunks <- split(exp_dist, ceiling(seq_along(exp_dist)/chunk_size))
p3 <- hist(sapply(larger_chunks, mean))

plot( p1, col=rgb(0,0,1,1/4), xlim=c(0,10), ylim=c(0, 4), freq=FALSE)
plot( p2, col=rgb(1,0,0,1/4), xlim=c(0,10), ylim=c(0, 4), freq=FALSE, add=T)
plot( p3, col=rgb(0,1,0,1/4), xlim=c(0,10), ylim=c(0, 4), freq=FALSE, add=T)

legend(
    "topright",
    pch = c(15, 15),
    col = c(col=rgb(0,0,1,1/4), rgb(1,0,0,1/4), rgb(0,1,0,1/4)),
    legend=c("Exponential", "Mean of Means from small chunks", "Mean of Means from large chunks")
)
```

![An plot of mean values sampled from chunk sizes 1, 10, 100](../images/mean-of-means/histogram-multi-comparison.png)

It appears to be converging around something which you've probably already guessed -- the mean of
the distribution!

$$
\begin{align*}
\bar x &= \frac{1}{N}\sum_{i=0}^N x_i\\
       &= \frac{1}{N}\sum_{j=0}^{10}\sum_{i=0}^{N/10} x_{ij}\\
       &= \frac{1}{N}\sum_{j=0}^{10}\bar x_j
\end{align*}
$$

That the _mean of means_ is equal to the _mean_ is obvious given we have not touched the LHS of the
equation. What isn't so obvious is the shape of the variance that we obtain -- a suspiciously
normally distributed shape... and then it hit me during this write up: this is the [_central limit
theorem_](https://en.wikipedia.org/wiki/Central_limit_theorem), how on Earth had this not stood out
to me sooner? In hindsight this should've jumped right out at me but alas as Cosma Shalizi pointed
out statistical physics contains no actual statistics so certainly an ex-physicist would not be so
quick on the draw. Sometimes however, the obvious only becomes clear as you are in the process of
writing down your thoughts as you jog your memory. **Patience, humility and joy is required as you
enjoy "discovering" something you once knew as a teenager but have since almost forgotten a decade
later.**

Bonus: A Bug in Real Life, Batting Averages
---------------------------------------------------------------------------------------------------

As a sidebar, when we did do the resampling without replacement it is important to note that we
drew samples of the save size. If the sum were not be broken down into equal sizes there would be a
left over term required in the equation we presented. If these left over terms existed the _mean of
means_ would not preserve the original _mean_ as we can trivially show below

$$
\frac{1 + 2 + 6 + 10 + 15}{5} \neq \frac{1}{5}\left(\frac{1 + 2}{2} + \frac{6 + 10 + 15}{3}\right)
$$

with a little math we can however show that this can be easily corrected by using a weighted
average where the weights are proportional to the amount of items in the mean

$$
\frac{1 + 2 + 6 + 10 + 15}{5} = \frac{1}{5}\left(2\frac{1 + 2}{2} + 3\frac{6 + 10 + 15}{3}\right)
$$

This innocuous investigation has brought us to a similar real world example -- outside of code --
where storing all the numbers was decided to be too expensive/arduous and to save effort the means
of varying sized groups were stored instead: baseball batting averages.

The example I am pulling from is a real world example mentioned in the Wikipedia article on
[Simpson's Paradox](https://en.wikipedia.org/wiki/Simpson%27s_paradox#Batting_averages)

```
                           1995               1996           Combined
               ----------------    ---------------    ---------------
Derek Jeter      12/48     .250    183/582    .314    195/630    .310
David Justice  104/411     .253     45/140    .321    149/551    .270
```

It is interesting to note that for each year David Justice had a higher batting average than Derek
Jeter but over the period of two years Derek Jeter had a higher batting average than David Justice!


Follow Your Nose Wherever it Goes
---------------------------------------------------------------------------------------------------

I often hear the need for a [T-shaped skill set](https://en.wikipedia.org/wiki/T-shaped_skills):
the requirement to have deep knowledge in one thing while maintaining a semi-proficiency in other
things. Up till now I have mostly envisioned the base of the "T" as understanding the jargon of a
field to the point where you are not intimidated. However it is interesting that we talk about
"code smells"<sup>[3](#smell)</sup> but not other "smells" we have developed. Statistics, math,
physics, linguistics, chemistry, board games, personal investing -- certainly smells exist in these
fields. The positive descriptors could be called: intuition, guts, style, prettiness. The negative
descriptors: err, foolish, clunky, ugly, bulky. Are all these descriptions just not a personal
matter of objective expression? Smell seems like such a vulgar term. It invokes the image of a
shrewd nose rather than a cute boar sniffing out truffles. Perhaps, this perception is solely my
own. At the very least I do not have a better term to suggest.

Summary
---------------------------------------------------------------------------------------------------

We have discussed that the variance of subsampled means is not neccessarily equivalent to the
original variance of a distribution. It is a normal distribution as outlined in the [_central limit
theorem_](https://en.wikipedia.org/wiki/Central_limit_theorem) with a mean equal to that of the
original distribution. In the case of varyingly sized darws if a weighted average is used or the
special case of all weights being equal occurs the _mean of means_ contiues to be equivalent to the
_mean_ of a distribution. In other cases where the weighted average is not taken to account it is
possible to derive false inferences via a well studied statistical topic known as [Simpson's
Paradox](https://en.wikipedia.org/wiki/Simpson%27s_paradox#Batting_averages). Briefly, at the end,
I stared into the abyss and quickly looked away before the abyss stared back into me as I
questioned why we use the word "smell" to describe code. [It is well known that smell is the sense
most closesly associated with memory](https://youtu.be/sKnZBqBLhBc?t=232), so perhaps that's all a
code smell needs to mean philosophically -- something faint and lingering which triggers our
memorys of code or statistics past.

Footnotes:
---------------------------------------------------------------------------------------------------

<sup>[1](#meetup)</sup>: Can we just take a second to appreciate that was given at a 2010 New York
Machine Learning Meetup? It seems so different from all the other ML meetups I've gone to in recent
years.

<sup>[2](#mode)</sup>: While I have no link readily available to a physical interpretation
explained online it should be readily clear that a physical analogue of the mode would be the
densest point in some physical object by analogy after establishing an intuition from the two prior
links.

<sup>[3](#smell)</sup>: I have talented friends who do not believe in the concept of a code
"smell". Disbelief of a concept however, does not negate the existence of the concept itself as a
being in the world. I can firmly say the Earth is round and not entertain the validity of a
"flat-earth" despite a recent up-tick in "flat-earthers". That however, does not mean that the
concept of "flat-earth" does not exist -- rather it has been misappropriated out of the context of
the local approximation in which it _is_ entitled to exist. Here, I will defer the reader to the
excellent Isaac Asimov essay on the [Relativity of
Wrong](https://en.wikipedia.org/wiki/The_Relativity_of_Wrong).
