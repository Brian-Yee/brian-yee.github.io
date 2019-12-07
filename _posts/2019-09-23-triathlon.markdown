---
title:  🏃 Percentile Values to Measure Triathlon Performance
date:   2019-09-29 00:00:00
layout: default
categories: [""]
author: Brian Yee
---

Code for generating the plots and values can be found
[**here**](https://github.com/Brian-Yee/triathlon-percentile-assessment).

Triathlon
=========

My Fiance is a gazelle. I have no clue how she runs so swims, bikes and runs so fast. In the
slightly less than two years that we've started our triathlon journey she has landed solidly at the
front of middle pack. The reason why is quite simple she's consistently more consistent than I.
This perhaps grew out of her mom being a competitive marathoner or the fact that she lived with
some Olympic runners for a few years but suffice to say that her later life experience has eclipsed
the impressive track record I held as a cyclist as a teenager. This was made extremely evident when
she put together a fantastic race this weekend at a [Half
Ironman](https://en.wikipedia.org/wiki/Ironman_70.3) (1.9km swim, 91km bike, 21.1km run) we both
raced in.

Nevertheless, just as there exists no straight line in nature, the path to personal success is
never linear. All I can do is keep trying to get better and slowly improve. My swimming has gotten
better, my cycling has gotten better and my running has gotten better. The only problem is the
final run at the end of the triathlon is where I crash. Like Matt Dixon, [I run like a donkey
dipped in cement](https://www.purplepatchfitness.com/the-dixonary). In terms of triathlon it is
extremely apparent that it is my weakest link. Despite being able to put together a 25min 5k and
2hr half-marathon as isolated personal bests in running. While personal bests are usually pegged at
some nice round numbers triathlons can vary wildly and the terrain can have massive impacts on
time. The need to race and view one's position to others is crucial to understand one's performance
contextually.

Measuring Race Results
======================

One way to measure your performance at a race is to look at your ranking in the age-group you are
assigned, your sex category, or overall. This however is wildly dependent on the number of entrants
in a race. Another technique used is time-off/percentage of the pros/elite division as they are
fairly consistent and are anchored around what is theoretically the possibly best for a given race.
As a programmer and machine learning engineer though this is an amazing scenario for a real-world
application of statistics know as [kernel density
estimation](https://en.wikipedia.org/wiki/Kernel_(statistics)#/media/File:Kernels.svg) (KDE).

The KDE method takes into account that on any given day things could've gone slightly differently,
for example before my last half-Ironman the fire alarm went off in the hotel the night before. This
disrupted our sleep and cascaded slightly into our morning preparation. In theory if more
applicants would enter you expect the other people who are like me but encounter different random
circumstances that either aid or impede their total potential to occur. Of course, luck can only
play so much part, most things _don't_ matter and it is our _consistent_ training to the day of
that impacts our final time. Thus we have to choose the distribution of just how much luck can
increase or decrease the observed data point the day of. How we define this luck is called a
_kernel_ and can come in many forms

[![alt](../images/triathlon/kernels.svg)](https://en.wikipedia.org/wiki/Kernel_(statistics))

Each of these kernels make an assumption on the distribution of luck but also are all _symmetric_.
That is to say that the kernels state that luck affects results the results equally in positive and
negative adaptations. This assumption isn't _too_ wild for our use but we can do better by using an
_asymmetric_ distribution. While I am no superstar runner it is useful to point out all the work
that went into the [Breaking2](https://en.wikipedia.org/wiki/Breaking2) project. It is much easier
to accidentally go slow than to accidentally go fast^[1]. Thus it would be preferable to use a
custom KDE using a [log-normal](https://en.wikipedia.org/wiki/Log-normal_distribution) distribution
that takes into account this additional piece of information. However given there exists no
pre-existing implementation of a log-normal KDE plot a Gaussian (normal) kernel and the solution
for asymmetric kernels is not clear in and of itself. A useful [CrossValidated
post](https://stats.stackexchange.com/questions/50056/kernel-density-estimation-on-asymmetric-distributions)
goes into this a bit more in depth, suffice to say that a bread-and-butter normal distribution will
be an easy first approximation sufficient enough for the efforts of this blog post!

Computing the Distribution
==========================

The way to calculate a KDE is dead simple. For each observed data point place a kernel above it.
Now "above it" is a bit vague. Where exactly for a distribution should we center it above the
point? One may be tempted to say the mean-value but remember that not all distributions _have a
mean value_! What may be tempted to say the median value as it is outlier-insensitive but a kernel
is only a local approximation so the other kernels will "wash" out any outliers per se. The mode
(serrputiously stated last) is the maximum a priori estimation and intuitively falls in line with
our idea that it is really hard to randomly go faster but easier to go slower, so we will add a
log-normal kernel centered about the mean above every data point from real-life observed. Doing so
yields the following image for my Half Ironman over the weekend.

[![KDE using log-normal kernels for a
Triathon](../images/triathlon/kde.png)](../images/triathlon/kde.png)

The best part about this is now we can measure our success as a percentile and better yet we can
compare our results from this time to last year!

$$
\begin{array}{llrrrr}
\hline
\text{Athlete} & \text{Year}  & \text{Swim} & \text{Bike} & \text{Run} & \text{Total}\\
\hline
\text{Me}      & 2018         & 20          & 23          & 04         & 08          \\
               & 2019         & 35          & 31          & 10         & 15          \\
\hline
\text{Fiance}  & 2018         & 40          & 62          & 52         & 55          \\
               & 2019         & 66          & 78          & 80         & 80          \\
\hline
\end{array}
$$

The results show I'm awfully slow but progressing and my fiance making some pretty amazing progress
this year. Still across the board unanimous raises in percentiles feels good!

Summary
=======

We have discussed kernel density estimates as a way of measuring one's position across races which
which have times highly dependent on courses. To do this we chose an appropriate kernel based on
some basic business logic and calculated the percentile values of our performance. While the
results show I'm a slow-poke -- I am a slow-poke that is improving. If only they put a math test as
the last part of a triathlon!!!
