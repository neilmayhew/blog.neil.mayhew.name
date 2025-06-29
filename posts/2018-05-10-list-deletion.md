---
layout: post
title: Deleting the largest element from a list
date: 2018-05-10 18:18:00 -0600
---
I was recently given a Haskell brain-teaser about deleting the largest element from a list. As you can imagine, it's effectively a one-liner in Haskell:

```haskell {.numberLines}
deleteMaximum [] = []
deleteMaximum xs = delete (maximum xs) xs
```

In Haskell, function arguments are separated by spaces, not parentheses and commas. The code uses two standard library functions, `maximum` and `delete`. The variable name is pronounced *'exes'* and is a common idiom for list names. The function definition uses case enumeration based on pattern matching, to avoid an error passing an empty list to `maximum`. Patterns are used in order, so the empty list is matched first.

However, the challenge gets much more interesting if the list is an infinite one, which is possible in a language with lazy evaluation. (You can actually define the list of all Fibonacci numbers and the list of all primes as one-liners.) The solution above makes two passes over the list, which is why it won't work for an infinite list, and is inefficient even for finite lists.

Surprisingly, it becomes possible with an infinite list if you're allowed to rearrange the order of the elements. Here's a real-world analogy of how it's done:

> You're faced with a line of people that extends to the horizon and beyond. Your task is to remove from the line the first person who is the tallest. (Others of equal height can remain.) You proceed as follows:
>
> Tell the first person in the line to step out of line and walk with you.
>
> If the next person in the line is taller than the one accompanying you, tell them to step out of line and walk with you, and tell the person who was previously with you to stand in their place. Otherwise, do nothing. Move to the next person in the line, and repeat.

If you have to remove all the tallest people instead of just the first, you need to have a group walking with you, and you insert the entire group into the line whenever you find a taller person.

Here's what this algorithm looks like in Haskell:

```haskell {.numberLines}
deleteMaximum (x:xs) = go x xs where
    go m (y:ys)
        | m < y     = m : go y ys
        | otherwise = y : go m ys
    go _ _ = []
deleteMaximum _ = []
```

This uses a nested helper function called `go`, which also uses case enumeration but using 'guards' (boolean conditions). The `:` operator is for prepending an element to a list (aka 'cons' in traditional Lisp terminology) and is also used for pattern matching and 'deconstruction' whereby parts of the input parameters are assigned to separate variables. So `(x:xs)` puts the first element ('head') of the list into `x` and the rest of the list ('tail') into `xs`. If the list is empty, it won't match the pattern and a different case will be used. Putting this case first increases performance slightly. Using `_` as a variable name is a placeholder for an unused value. Function application has higher precedence than operators like `:`.

Note that this implementation is also more efficient even for finite lists because it makes a single pass over the list.

To verify the correctness of the second implementation, I used Haskell's QuickCheck library to generate random inputs and compare the results against the first implementation (which I renamed `deleteMaximumModel`). This won't work for infinite lists, of course, but if it always works for lists up to 10,000 elements I feel fairly confident it's correct :-) . You do of course have to sort the two outputs in order to establish equality of the results, since the infinite implementation is reordering the list.

Testing in the interactive interpreter (`ghci`) looks like this:

```haskell {.numberLines}
> compareWithModel :: [Int] -> Bool
> compareWithModel xs = sort (deleteMaximumModel xs) == sort (deleteMaximum xs)
> quickCheck compareWithModel
+++ OK, passed 100 tests.
```

Note that you can also specify a maximum list size and a number of tests to try. QuickCheck is good at including edge cases, such as lists of length 0 and 1.

I had to include a type annotation for `compareWithModel` because `deleteMaximum` is actually generic, and `quickCheck` needs a concrete type to use when it generates random data. It's generic in that it will work for any element type that has a less-than operator (and in Haskell, that means it has to be a member of the typeclass `Ord`). However, it would be easy to add a version called `deleteMaximumBy` that takes an additional parameter specifying a comparison function, and to define the basic one in terms of the more general one. That way, the list could contain objects of type `Person` and you could define maximum according to various criteria (such as height, age or salary). For example,

```haskell {.numberLines}
deleteMaximumBy (comparing personAge) people
```

where `personAge` is an accessor function for the age property of a `Person`. `comparing` is a library function that applies the standard function `compare` to the result of running the given function on two elements (ie `compare (personAge a) (personAge b)`).

Infinite lists in Haskell are a bit like defining recursive iterator functions in C# or Python using `yield`. At any given time, the unexamined part of the list is still a 'thunk' that will evaluate more elements when called upon to do so. However, due to Haskell's optimization of tail-call recursion this doesn't blow the call stack. Without this, it's not possible to define infinite lists recursively, only procedurally (eg with a `for` loop).
