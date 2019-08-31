Christmas Time (not) in the City
----------------------------------------------------------------------------------------------------

My fiance comes from a small rural town on the edge of Quebec. Every Christmas consists of doing
things "the old fashioned way": chopping down a tree from a nearby pine-tree lot, stoking the fire
with wood that split in Fall and listening to the local radio station talk about the town and play
tunes. Honestly it was a bit of culture shock at first but eventually I have come to really look
forward to it. The music the radio plays is not the same polished Michael Buble or Christina
Agulara but more country banjo stuff like Grandma Got Run Over by a Reindeer or Boney
M.<sup>[1](#santa)</sup> Still there are some aspects of her home town that just drive me a bit
nutty and a recent discussion of what the local radio has been aggrandizing is particularly
aggravating.

Betting on A House of Cards
----------------------------------------------------------------------------------------------------

Recently, apparently, a local fundraiser has been employed for the town to raise money for the
local hospital. It consists of buying 5 dollar tickets (3 dollars of which go to the hospital, 2 of
which go to the prize purse) that are accumulated by an individual over a week and used in the
following manner

1. Out of all the tickets bought throughout the week *one is drawn as a "winner"*
2. The "winner" gets a chance to draw a card **from a shuffled deck***, if the Ace of
   Spades is draw they win the prize purse and the event terminates
3. If the Ace of Spades was not the card from the deck that was draw **is removed** and the event
   proceeds to the next week, beginning again from step one.

Apparently this gambling fundraiser has drawn the attention of the town folk with much radio
coverage from that same radio station that I tune into every Christmas. They now find themselves in
Week 18 of the event and people are getting jumpy. Apparently last week someone bought _5000
dollars_ worth of tickets on top of approximately another _1000_ dollars worth that had been bought
by people that week. I really don't like gambling and I really _really_ wanted to explain just how
crazy this felt to me. I took this as a challenge for my communication skills to try and explain
why the fact that "every week you get more likely to win and nobody has won yet" is a terrible
terrible argument.

Now I'm sure the reader's of this blog are likely also aware that in general gambling is bad -- the
house always wins. I encourage the reader however to take sometime to close the laptop, stare at
the ceiling and think of the most convincing argument given the facts above to tell a layperson
_why_ you feel it is a bad idea. I found it surprisingly difficult _using only mental calculations_
to succinctly express my thoughts.

Do Ya Feel Lucky?
----------------------------------------------------------------------------------------------------

I'm going to break these my personal thoughts on this specific gambling event although. I should
note that off the cuff my argument was formed of point (1) followed immediately by point (4). The
other points were ones I thought of while trying to fall asleep that night.

### How Long Does This Game Last on Average?

That is to say what is the expected value of rounds for this game? However, expected values are
hard for a person without statistics to _grok_. To fully emptahize with my audience (my fiance's
Dad) I need only consider how lost I am when he talks about snowblower parts and auto-repair. One
may believe their explanation of an expected value was understood because the other person said
"yes" but it is often very hard to discern where politeness ends and understanding begins. Let's
reword the question to

>Usually how long does this game last?

As a refresher let's review the rules

1. Draw a card
2. If ace terminate
3. If not ace remove from deck
4. Reshuffle
5. Go to (1)

Let's reconsider step (4) is it really necessary or is it just added to additionally confuse us
when evaluate the probability our probability of winning? If the deck was randomly shuffled at the
start what does shuffling it again do? It certainly does not increase the remaining randomness. One
Ace of Spade exists in the remainder and it's placement is not known, step (4) is superfluous. The
question really then is

> On average where do you expect a specific card in a shuffled deck to be?

The answer of which should straightforwardly be

> In the middle.

Why? Because a "random" deck means _uniformly random_ perhaps more understandably as one where our
probabilities are "_even_" in the sense of "_fair_**. Sometimes we expect the card to be near the
top. Sometimes we expect it to be at the bottom. Sometimes it will be near the middle. On average
we would expect these to balance out towards the middle. The answer therefore is

> 26 rounds.

**Note one must be careful to differentiate a back-of-the-napkin calculations from what is
correct.** While "26 rounds" is correct enough on the grounds of mental _approximations_ to
proceed. If one hashes out the math it is actually 26.5 rounds<sup>[2](#stack)</sup>. The 1/2 card comes from the
need to keep drawing another card until the end is reached. Consider a deck of length 2. On average
we would draw the Ace of Spades on the first draw 50% of the time and the other 50% on the second.
The expected number of draws is then

$$
\mathbb{E}(X) = \sum_{i=1}^2 p_i x_i = \frac{1}{2} 1 + \frac{1}{2} 2 = \frac{1}{2}(1 + 2) = 1.5
$$

More abstractly let's consider a deck of length \\(n\\)

$$
\begin{align}
   \mathbb{E}(X) = \sum_{i=1}^n p_i x_i &= \frac{1}{n}(1 + 2 + 3 + 4 + \ldots + n)\\
   &= \frac{1}{n}\frac{n(n+1)}{2}\\
   &= \frac{n+1}{2}\\
   &= 0.5 + \frac{n}{2}
\end{align}
$$

Where I have used the _triangular number_ formula to re-express the sum of \\(n\\) positive
integers. If you still are uncomfortable with an _intuition_ about how an additional 0.5 is
_always_ present _constantly_, read up on triangular numbers and note how the diagonal is handled
in the visual interpretation.

### How Many More Rounds of the Game can We Expect?

Consider our above argument, the (approximate) answer \\(26\\) came about _because_ we were
discussing a deck length of \\(52\\). Nothing here however is special about \\(52\\) they could as
well of started with two decks of half a deck and all the math would be the same. Thus when the
radio keeps saying

> How much longer will this game last?!

We know the solution to their question was outlined above -- the game is expected to last half the
length of the current size of the deck. There have been 18 rounds so far so:

$$
\frac{52 - 18}{2} = \frac{34}{2} = 17
$$

we would expect the radio will have (approximately) 17 more weeks of coverage left.

### Give you Choose to Play how do you Maximize your Return on Investment?

Okay so there are 17 weeks of coverage left, up till now we have only considered the mechanics of
play and not the human component -- here we will choose to continue examining the mechanics one
last step before considering how playing the game with other humans changes things.

> Given we expect 17 more weeks of this when should we play?

The answer is not complicated:

> When you are okay with the odds

The odds being determined as one out of the remaining cards in the deck. That means that if you are
comfortable with a \\(10%\\) chance of winning -- which means a \\(90%\\) chance of **losing** you
should only start to play the game when there are 10 cards left. If you are okay with a \\(95%\\)
chance of losing play when there are \\(20\\) cards left.

Now, granted the previous answer is a bit boring, one might imagine that it depends on the prize
purse remaining which could of grown at some other rate determined by other external players.
Surely if _nobody_ bought _any_ tickets this week but the prize-purse carries over from last week
and you could guarantee a potential draw by acquiring one ticket at five dollars while the
prize-purse that had compounded from prior weeks to something like _ten thousand dollars_ you'd be
insane not to buy a ticket to get the potential payout. So there exists **some region** where it is
beneficial to play and if and when you are in the region

Mathematically you wish to buy when

$$
\small
\begin{align}
   \text{payout}\left(\frac{1}{\text{deck size}}\right) &> \text{investment}\left(\frac{\text{my tickets}}{\text{total tickets}}\right)\\
   \frac{\text{payout}}{\text{deck size}} &> \left(5 \times \text{my tickets}\right)\left(\frac{\text{my tickets}}{\text{total tickets}}\right)\\
   \text{payout} &> \frac{5 ( \text{deck size} ) (\text{my tickets})^2}{\text{total tickets}}\\
   \text{money}_\text{prev weeks} + \text{money}_\text{this week} &> \frac{5 ( \text{deck size} ) (\text{my tickets})^2}{\text{total tickets}}\\
   \text{money}_\text{prev weeks}  &> \frac{5 ( \text{deck size} ) (\text{my tickets})^2}{\text{total tickets}} - \text{money}_\text{this week}\\
   \text{money}_\text{prev weeks}  &> 5 \left(\frac{( \text{deck size} ) (\text{my tickets})^2}{\text{total tickets}} - 0.4 \times \text{total tickets}\right)\\
   \frac{\text{money}_\text{prev weeks}}{5}  &> \frac{( \text{deck size} ) (\text{my tickets})^2 - 0.4 \times (\text{total tickets})^2}{\text{total tickets}}\\
   \frac{\text{money}_\text{prev weeks}}{5}  &> \frac{( \text{deck size} ) (\text{my tickets})^2 - 0.4 \times (\text{my tickets} + \text{other tickets})^2}{\text{my tickets} + \text{other tickets}}\\
\end{align}
$$

this is getting pretty terse lets rename the functions now that we are more concerned with their
form

$$
\small
\begin{align}
   \frac{z}{5}  &> \frac{ N x^2 - 0.4 (x + y)^2}{x + y}\\
\end{align}
$$

It would be very interesting to plot this but this would require more domain knowledge about what
round we are in and how funds accrue as rounds continue further on. However now we can at the very
least partake while obeying the Ontario Gambling Slogan

>Know your limits and play within it

or perhaps more accurately

>Know your inequalities and play within it

Anti-climactic? Sure. Let's give a concrete example of what we know from the data we were told.

### A Concrete Example of the Diminishing Returns Investing 5k at Round 17.

The chance of winning at round 17 was \\(1/(52-17) \sim 2.1\%\\). The funds already invested in
were \\(1000\\). A reasonable assumption could be that given people get excited that chances go on
week to week the upper bound of what we could reasonably be expected to of been bought in tickets
is \\(1000\$\\) for each week prior or \\(17\text{k}\$\\), keep in mind that \\(60\%\\) goes to the
house so the left over prize purse was \\(4 \times 17/10\text{k}\$\\). The chance of
winning is obtained by multiplying the two mutually exclusive probabilities for a given round

$$
\begin{align}
   p(\text{winning}) &= p(\text{drawing ace of spades}) \times p(\text{having winning ticket})\\
   p(\text{winning}) &= 2.1\% \times p(\text{having winning ticket})
\end{align}
$$

Expressed in this form it is clear to see that buying tickets only allows you to gain access to a
slim possibility but buying more tickets gives you diminishing returns. Back of the napkin mental
arithmetic arrives us at

$$
\begin{align}
   p(\text{having winning ticket}\ |\ \text{investment}) &= \frac{\text{your tickets}}{\text{your tickets + others tickets}}\\
   p(\text{having winning ticket}\ |\ \text{5k})  &= \frac{5}{5 + 1} \sim \frac{5}{6} \sim 84\%\\
   p(\text{having winning ticket}\ |\ \text{2.5k})  &= \frac{2.5}{3.5} \sim 3 \times 0.25 \sim 75\%
\end{align}
$$

using our mental approximations

$$
9\% \sim p(\text{having winning ticket}\ |\ \text{5k}) - p(\text{having winning ticket}\ |\ \text{2.5k})
$$

which I'm gonna say is \\(10\%\\) because I know approximating \\(3.33\%\\) as \\(3.5%\\) was an
underestimate.<sup>[3](#rounding)</sup> Therefore the _gain_ in chances from investing \\(\text{2.5k}\\) vs
\\(\text{5k}\\) for tickets at round \\(17\\) is

$$
p(\text{winning}\ |\ \text{5k}) - p(\text{winning}\ |\ \text{2.5k}) = 2.1\% \times 10\% \sim 0.2\%
$$

Everyone's risk appetite is different -- lives our sufficiently complex that there exists other
opportunities to the gambler such that the money now could be re-leveraged in a smart way still
spending out \\(\text{2.5k}\\) for an increase of \\(0.2\%\\) is probably not what the original
buyer had in mind when they purchased the other half of his tickets.

Ethos, Pathos, Logos
---------------------------------------------------------------------------------------------------
The reader probably now asks, what is the point of this post? Everyone _knows_ that gambling is not
a wise investment and this blog post is not gonna do anything to prevent people from gambling. I
can't even persuade my dad to stop buying his weekly lotto ticket (because it is "only 2 or so
bucks"). The reason I wrote this is two-fold

1. It is a simple enough game that I was able to use back-of-the-envelope mental calculations to
   help explain the game to someone without a statistics background and the act of that mental
   calculation and pragmatic result in a concrete use case is a fun exercise showing basic
   arithmetic can have real life applications.
2. In [Aristotle's Rhetoric](https://en.wikipedia.org/wiki/Rhetoric_(Aristotle)) he discusses the
   three main modes of persuasion being the _ethos_ (credibility), _pathos_ (emotion), _logos_
   (reasoning). Most of the time arguments I observe against gambling are of the _logos_: rational
   arguments about the probabilities. Pitted against the _something_ they are likely doomed to fail
   in casual discussion. Your chance of winning may be the same as "being struck by lightening" but
   the _conception of the payout_ is so irrationally large that the intuitive expected value still
   views it as a positive move. It is my hope in writing an article about this that the next time I
   talk to someone within my close circle (such as my dad) I can express that my disapproval is on
   the level of actually causing me to write about a specific case of gambling I saw that affected
   my fiance's hometown. When I use this argument I hope to appeal to their view of my _ethos_ and
   _pathos_ as someone who really does care about close ones gambling (unless it's passive
   investing).

Summary
----------------------------------------------------------------------------------------------------
We have discussed a real life gambling event in which basic probability and arithmetic were found
to be useful. We discovered that interestingly the mean value of locating a card anywhere within a
deck is halfway through the deck plus half a card (e.g. 52 card deck shuffles a specific card on
average to 26.5). We saw that in games where you enter a draw to win a share of the pool prize a
positive return _is possible_ but dependent on the previous weeks prize purse and other peoples
investment at the current round. To give a tractable understanding of the equation a concrete
example of last week's scenario was shown to have diminishing returns. Finally the reason for
writing this post was clarified so as to highlight the central theme -- putting my money where my
mouth is and spending some time writing about how I strongly find casual gambling to be a poor
investment.

Footnotes
----------------------------------------------------------------------------------------------------

<sup>[1](#santa)</sup>: I have still however, have yet to hear Don't Shoot me Santa Claus on any radio station despite
putting it on my wishlist for Santa every year.

<sup>[2](#stack)</sup>: Here is a generalized from of the question I posed for playing the game until \\(k\\) specific
cards are drawn from a deck of \\(n\\) cards detailed on [stackexchange
link](https://math.stackexchange.com/questions/206798/pulling-cards-from-a-deck-without-replacement-to-reach-a-goal-average-draws-nee).

 <sup>[3](#rounding)</sup> the actual value is \\(11.9\%\\)
