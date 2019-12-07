---
title:  💩 Using TF-IDF to Search Emojis Using English
date:   2019-12-07 00:00:00
layout: default
categories: [""]
author: Brian Yee
---

If You're Gonna Do It Three Times Do It Right
=============================================

What I've Heard
---------------

As a younger lad (I think as an undergraduate) I came across a user posting to a forum saying
something along the lines of the following:

>I did a MSc in Computer Science... honestly I don't remember much of what I studied but I did take
>something my advisor to heart "If you have to do something three times, automate it."

The first thing somebody ought to point to is the following xkcd comic

<p style="text-align:center">
    <img alt="xckd automation" src="../images/emojis/is_it_worth_the_time.png">
</p>

Which points out that the time invested in automating things doesn't necessarily pay out in saving
time on things. However, this is a surface level view of automation there are 3 things one gains
other than time from trying to automate something

1. Getting better at automating so future automations do not take as long
2. Being able to leverage that skill to save some time when scaled across others
3. Being able to save the cost of _context switching_ for yourself and others

Each of the points leads into the other but the most important to me is the last. The _context
switch_ can be so expensive. It is not the time that it requires -- often it is less than 10 or 15
seconds but it is the _potential to get distracted_ not to mention the mental fatigue that can
accrue when they are performed too frequently. I believe the majority of the reason to automate
something is not to save time but to save mental expenditure.

In this viewing the above quote on automation takes on a different light. It is not that a
successful programmer needs to automate everything but that the _specific thing they are paying
attention to_ that is occurring three times likely requires a non-negligible amount of mental acuity
that is better spent on defining and automating the process than simply _doing_ the process. I have
since internalized and modified that quote for myself as

>If you're gonna do it three times do it right

A Thought Occurred
------------------

Recently, my post count had grown to 17 posts creating a wall of text that greets the user. A
though occurred to me perhaps that putting a single emoji, contextually relevant to the title would
remove the "wall'iness" of the wall of text, since humans visual processing of images is
approximately [an order of magnitude faster than
text](https://policyviz.com/2015/09/17/the-60000-fallacy/). Perhaps a small left aligned emoji
could capture and provide a visual cue for something they may be interested in. The only way to
know would be to put an emoji in front of each and see what impression I left on myself.

Of course development, is done on a laptop not a phone so emojis are not built into my keyboard...
nor should they be (looking at you Apple smartbar). In the past if I have required an emoji it is
either built into the service (like slack) or I need to search `<something> emoji` in DuckDuckGo
and go through the surprisingly painful process of copying the emoji text which sometimes will be
padded with hidden text. Another alternative is to go to the [Wikipedia Page on emojis]() which
lists all emojis in a unicode tabulation.

While emojis are located with some contextual relevance in their unicode tabulations it can still
be hard to find the emoji you want. Besides, looking in the table requires you to know what you
want and get creative. It would be beneficial to have a program that pruned or sorted (or both) the
set of emojis so that you could get creative on a smaller candidate subset.

Collecting Emoji Data
=====================

Now to pare down the set of emojis requires understanding emojis. Surprisingly there is a pretty
large [subcommunity](https://emojipedia.org/) dedicated to understanding what may be called an art
or science of emojis. However, the descriptions aren't so verbose as to be much data and a quick
search uncovered to API or Terms of Service conducive to building a program. Luckily the [Wikipedia
Page on emojis](https://en.wikipedia.org/wiki/Emoji) that tabulates all emojis based on their
unicode values has a redirect link to a relevant Wikipedia page that encompasses what the emoji is
_literally_ supposed to represent. Using the Wikipedia API we can get resolve these redirects

```python
SESSION.get(
    os.path.join("https://en.wikipedia.org/api/rest_v1/page/summary", href),
    allow_redirects=True,
).url
```

and parse the html on the page

```python
data = SESSION.get(
    url="https://en.wikipedia.org/w/api.php",
    params={"action": "parse", "page": page, "format": "json"},
).json()

data["parse"]["text"]["*"]
```

where `SESSION` is a `requests.Session` object. Using `BeautifulSoup` we can collect all `td`
elements with that have `mw-redirect` as a class and store them in a JSON of emoji to corresponding
Wikipedia Page. Then we loop over that table and save the `html` locally for referencing. Thus for
the 🍣 emoji we have a `Sushi.html` file stored amongst others in `data/html` that stores the html
of the [Sushi Wikipedia Page](https://en.wikipedia.org/wiki/Sushi).

TF-IDF: A God Tier Heuristic Algorithm
======================================

Contains Query
--------------

The simplest way forward from here would be to simply write a script that returns a list of emojis
that contain the query word in the text of the HTML. We can bypass the heaviness of `BeautifulSoup`
by opting for `lxml` from now on and simply collecting all nodes with text

```python
tree = etree.fromstring(html)
text = "".join(tree.xpath(".//text()"))

in_text = query in text
```

mathematically

$$
\lbrace d \in D : t \in d \rbrace
$$

where \\(D\\) is the set of documents and \\(t\\) is the queried term

Contains Most of the Query
--------------------------

It is hardly a stretch of imagination to suppose that we ought to return the files which contain
the query term the most often. Which can be calculated as

```python
text_count = collections.Counter(text).get(query, 0)
```

mathematically we introduce a new term that we can sort by

$$
f_{t, d} = \sigma_{w \in d} \delta(t, w)
$$

where \\(w\\) is a word in a document. This prioritizing however favours long documents so we
counterbalance this by normalizing against the number of words in a docment

$$
\text{tf}(t, d) = f_{t, d} / \sigma_{w \in d} f_{w, d}
$$

Term Frequency Inverse Document Frequency (TF-IDF)
--------------------------------------------------

Better yet we could try and understand the relative importance of a word to a document by comparing
it's frequency across all documents. Obviously "the" will be one of the highest terms
proportionately for any document but it isn't particularly descriptive of any document. We will
then counterbalance this weight by calculating the frequency of the term across all documents

$$
\text{tfidf}(t, d, D) = \text{tf}(t, d) \text{idf}(t, D)
$$

where \\(\text{idf}\\) stands for inverse document frequency and is calculated as

$$
\text{idf}(t, D) = \log\left\lbrace\frac{|D|}{|\lbrace d \in D: t \in d \rbrace|}\right\rbrace
$$


where we define the IDF to be logarithmically scaled _because it works!_. In fact there are many
ways up to this point that we could have defined the TF and IDF terms as proposed variations that
also work. All TF-IDF weighting schemes however always adhere to the multiplication at the end. .
This is perhaps the most amazing thing about TF-IDF it is a simple _intuitive_ model that was
defined _back in 1972_ and the theoretic justification of why it works is still not well
understood. There have been attempts aimed from information theoretic justifications or pointing
towards [Zipf's Law](https://en.wikipedia.org/wiki/Zipfs_law) in linguistics but there is no
definitive answer after almost half a century. Yet it's widespread adoption and use in information
retrieval has made it in my humble opinion a god-tier heuristic algorithm.

Apply TF-IDF to Search Emojis
=============================

For brevity, the meat of this post is focused around explaining what TF-IDF and show how it can be
applied to a real use case -- not to elaborate on a full-blown implementation. It shall suffice to
say that one can easily use `nltk` for their preprocessing pipelines and the
`sklearn.feature_Extraction.text.TfidfVectorizer` object to do the grunt work for themselves. Using
a custom preprocesser that stems, removes stops and html tag-like terms and enforces a minimum of
two words that must occur in a document we can calculate the TF-IDF vector as

```python
vectorizer = sklearn.feature_extraction.text.TfidfVectorizer(
    max_features=10000, min_df=1, preprocessor=preprocess
)

weights = vectorizer.fit_transform(corpus)

model = {
    "weights": weights,
    "columns": vectorizer.get_feature_names(),
    "index": index,
}
```

were a `feature` to `sklearn` represents a term to take from the set of documents and `index`
corresponds to the document ordering. If you would like to examine the full code yourself I have
uploaded the code to [my github account](https://github.com/Brian-Yee/cpemoji).

Trying it Out
=============

We now define a simple function to query our model (don't forget to preprocess your input!).

```python
def find_best_emojis(model, query):
    """
    Finds a sorted list of emoji matches.

    Arguments:
        model: dict(str, np.array)
            Artifacts of a trained TF-IDF model.
        query: str
            String to query model with.

    Returns:
        list(str)
            A sorted list of emojis ordered by their TFIDF weights.
    """
    words = preprocess(query, min_words=0)

    indices = []
    for word in words.split():
        try:
            idx = model["columns"].index(word)
        except ValueError:
            continue

        indices.append(idx)

    if not indices:
        return []

    sorted_args = (-model["weights"][:, indices].toarray().sum(axis=1)).argsort()

    emojis = []
    for arg in sorted_args:
        if np.isclose(model["weights"][arg, idx], 0):
            break
        emojis.append(model["index"][arg])

    return [a for b in emojis for a in b][:5]
```

and take apply that function over a loop of terms

```
ice cream         ['🍨', '🍦', '🍧']
irish cream       ['🍨', '🍦']
bad apple         ['🍎', '🍏', '↔️', '🌼', '📱']
the fuzz          []
cycling           ['🚴', '🚲', '🚳', '🚵', '📅']
drinking          ['\U0001f964', '🚰', '🍹', '🍻', '🥂']
street racing     ['🏍️', '🏇', '🏎️', '💨', '🏁']
asdf              []
canada            ['🍁', '💂', '🏒', '🛂', '📪']
cat               ['🐈', '🐱', '😸', '😺', '🐆']
japan             ['🗾', '🎌', '💮', '🏣', '💴']
burger            ['🍔', '\U0001f96a', '\U0001f9c6', '🍗', '🐫']
drugs             ['😕', '😖', '💊', '💫', '😵']
rock              ['\U0001f9d7', '🤘', '\U0001f94c', '⛰️', '🏔️']
ham               ['\U0001f969', '\U0001f96a', '🥓', '🍖', '🔪']
meat              ['🍖', '\U0001f969', '🍔', '\U0001f95f', '🍳']
panda             ['🐼', '🐻', '\U0001f960', '\U0001f9a8', '🐆']
dragon            ['🐉', '🐲', '\U0001f9dc', '\U0001f9d9', '🀄']
chinese           ['👲', '\U0001f9e7', '🐉', '🐲', '🈚']
american          ['🆗', '🏈', '\U0001f960', '🤠', '\U0001f91f']
bike              ['🚵', '🚴', '🚲', '🚳', '\U0001f6f7']
football          ['🏈', '⚽️', '🥅', '🏉', '🏟️']
motown            []
colombia          ['🛃', '🚞', '🛑', '🌦️', '🌧️']
students          ['💮', '🏫', '🎓', '😐', '😑']
phone             ['🔕', '📴', '📵', '📶', '📱']
beer              ['🍺', '\U0001f964', '🆓', '🥃', '🍸']
watch             ['⌚️', '🕐', '🕑', '🕒', '🕓']
samurai           ['🏯', '🎌', '🆒', '😎', '⚔️']
cartoon           ['\U0001f9b9', '🗨️', '💬', '💭', '🗯️']
computer          ['💻', '🖥️', '⏏️', '🖱️', '🆑']
christmas         ['🎄', '🎅', '🤶', '☃️', '⛄️']
jesus             ['🙇', '😇', '🏳️', '🕊️', '🕋']
magic             ['\U0001f9d9', '🎱', '\U0001f9ff', '🔯', '⚕️']
existentialism    ['😧', '🔏', '🤔', '👩', '🚺']
philosophy        ['🤔', '😧', '\U0001f929', '↔️', '☯️']
religion          ['☸️', '🛐', '💯', '🐓', '\U0001f9ff']
ramen             []
avocado           ['🥑', '🍣', '🍔', '🥗', '🌮']
tamago            []
sashimi           ['🍣', '🔪', '🐡', '🐬']
sushi             ['🍣', '🍙', '🎑', '🍤', '🍠']
```

Python and iterm doesn't render all the emojis but the majority are displayed allowing us to yield
surprisingly useful results and better yet some that I would not of traditionally thought of. For
example burger shows up in "avocado" because in Mexico avocado is a popular topping of burgers and
samurai shows "cool" glasses because of a slang term in Japan. Due to an excessive amount of word
play in my titles passing the full string don't usually yield the best results. However I can
quickly sum up the title in one word and see the candidate sets to choose from.

```
emojis            ['🙋', '🙎', '😂', '😹', '💩']
hook              ['🎣', '☎️', '🤘', '\U0001f9be', '\U0001f9bf']
game              ['🎮', '🎰', '🎴', '🏃', '🕹️']
secure            ['🛂', '🔏', '🏧', '🤐', '⏏️']
write             ['✍️', '〽️', '🈂️', '📓', '📔']
art               ['🎭', '🏵️', '👼', '🍜', '🌆']
puzzle            ['\U0001f9e9', '😕', '😖', '🎮', '📕']
lost              ['💔', '\U0001f9b2', '\U0001f9d9', '🛅', '\U0001f9f3']
sports            ['\U0001f94f', '🏃', '⛹️', '🏈', '🤽']
spider            ['🕷️', '🕸️', '\U0001f9b8', '\U0001f9b7', '🦀']
cheese            ['🧀', '🍕', '\U0001f96a', '\U0001f9c6', '🔪']
amplifier         ['📣', '🔈', '🔉', '🔊', '🎧']
reptile           ['🦎', '🐍', '💀', '🐊', '🐢']
Die               ['🎲', '🎱', '💔', '🌿', '✊️']
nose              ['👃', '😷', '\U0001f93f', '👄', '\U0001f6f9']
binoculars        ['👀', '👁️', '\U0001f996', '🦉', '🌞']
tool              ['🛠️', '\U0001f9f0', '📐', '📏', '⛏️']
```

Now all that's left is to copy and paste an emoji in front of every title across my markdown files.

Summary
=======

We have given a real world example of how to use TF-IDF to organize and query data in such a way to
organize a list of documents. These list of documents correspond to wikipedia page descriptions of
the various emojis allowing us to easily obtain a feel for the accuracy and contextual relevance of
this method quickly. The implementation of TF-IDF was not shown however as this post focused purely
on the motivation and intuition behind TF-IDF. If the reader would like to see all the machinery to
parse the Wikipedia data and creating a preprocessing pipeline to feed into the TF-IDF vectorizer
the code is available [here](https://github.com/Brian-Yee/cpemoji). In the end the code proved
useful for quickly identifying an emoji for the previous titles of all my posts and as importantly
will continue to be of use for future posts as well!
