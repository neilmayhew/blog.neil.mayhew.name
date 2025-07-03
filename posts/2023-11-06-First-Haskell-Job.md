---
layout: post
title: Getting Your First Haskell Job
date: 2023-11-06 15:37:23 -0600
---

Someone asked,

> Does trying to get a Haskell job make sense anymore?

There are really two parts to this question:

1. Is working in Haskell still worthwhile?

2. Is it too difficult to get a Haskell job nowadays?

## Is working in Haskell still worthwhile? ##

I've been in Haskell-only jobs for the past 6 years and was using Haskell for non-critical work tasks and in my own time for 8 years before that. I have many more years of experience in C++, Python, C#, Smalltalk and lots of other languages.

I'm consistently astonished by what Haskell enables me to do in terms of writing correct, robust, performant and maintainable code in production settings compared with other languages. Haskellers talk about "fearless refactoring" and I've found that to be true in my own experience. In one example, I and one other engineer did a very significant refactoring of a medium-sized codebase (50KLOC of Haskell, equivalent to about 150KLOC of Java or C++ or about 100KLOC of Python). It took us about 3 months and when it was finished it worked first time in production and had no refactoring-related bugs that needed to be fixed afterwards. In addition, there was an immediate 40% increase in performance. I can't think of another language in which that would have been possible let alone likely.

You could say that superheroes can do that in Haskell but not the average person. I disagree. In a recent project we hired two new graduates who had used Haskell a bit in university and in their own time. They were able to write very decent Haskell from day one of working on the project. When they did need guidance and mentoring, it was for the kind of things that would have been needed by a new graduate in any language and weren't specific to Haskell.

In particular, I disagree that being able to use Haskell well requires esoteric skills. Someone said,

> You can't just quickly pull a bunch of extremely smart mathematically minded people with logic and category theory knowledge out of thin air.

That may be true, but you don't need those skills to write Haskell. I still don't know category theory even though I've been using Haskell successfully for 14 years. In fact, I've found that if you get people who are too academically minded they don't write good production code and will tend to write very complex code using too much abstraction that ends up being very difficult to maintain.

## Is it too difficult to get a Haskell job nowadays? ##

There's a Catch-22 in the industry generally, unrelated to Haskell, that almost all job ads ask for a minimum of 2 years of experience. How is anyone to gain those 2 years of experience if no employer is willing to hire people without it? I call it the cuckoo effect. The cuckoo is a European bird (similar to the cowbird in the southern USA) that lays its eggs in other bird species' nests so that the other birds pay the cost of raising the chicks, often at the expense of their own chicks because the cuckoo chicks are bigger and louder. The cuckoo pays none of the cost of perpetuating its genes and freeloads off other species. Software engineering employers want to pay none of the cost of raising their own junior engineers and instead want to steal them from other employers as soon as they're trained.

This problem is unfortunately amplified when it comes to Haskell jobs. As I've suggested, there's a belief that esoteric skills and many years of experience are needed in order not to shoot yourself in the foot when writing Haskell. As a result, most Haskell job ads ask for 4-5 years of experience with Haskell in a production setting. That's completely unreasonable and short-sighted, and will kill the use of Haskell in commercial settings sooner than anything else. My experience has been that most moderately smart programmers with the right mindset can convert successfully to Haskell given a small amount of guidance and mentoring from someone experienced. I think the industry believes that about other programming languages, which is why it's relatively easy to get work in a new programming language once you have that magic 2 years of experience, but companies seem very unwilling to hire someone who doesn't know Haskell and let them pick it up.

This still doesn't answer the question, of course. How do you get around the problem? My own solution was to get hired on the basis of other skills by a company that had some involvement with Haskell and was willing to let me show whether I had the necessary Haskell skills after they'd gotten to know me for a while. If it turned out I didn't quite have the chops, there was still other work I could continue doing at the company. (My other skills were in DevOps and project leadership.)

Another, related, strategy is to get hired to work in a different functional programming language, such as Clojure, F# or Scala, where there aren't so many people chasing their holy grail of programming languages. Some of those communities are a lot smaller and much more willing to give people a try, because there are so few people who already have experience in those languages. Then, when you know another FP language fairly well, can show some personal projects in Haskell, and can do reasonably well on a Haskell coding test, you stand a chance of getting that crucial first Haskell job.

Sometimes companies are even willing to hire people with no professional FP experience but who have used Haskell outside of work, on the basis of their personal projects and their contributions to larger open-source Haskell projects. The professional network and reputation you build up through working with others on high-profile projects can be very helpful in both finding and getting Haskell jobs later on.

Finally, there are companies (usually bigger ones) that are prepared to train people in Haskell. However, those jobs don't come up very often so it's usually necessary to be patient, keep watching the feeds and play a long game.

Good luck! There are Haskell jobs around — I see them advertised in Haskell Weekly News almost every week — so don't give up too easily.
