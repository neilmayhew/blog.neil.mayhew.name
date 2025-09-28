---
layout: post
title: When Is An Exception Not An Exception?
date: 2025-09-20 20:54:06-06:00
---
As a child, I remember being irritated by the tired old joke, "When is a door not a door? When it's ajar!" However, I recently found myself asking much the same sort of question in a Haskell context — "When is an exception not an exception?" — and the answer was surprising.

I was trying to resurrect some very old Hackage code that was last updated in 2015 when GHC version 7 was king. I was able to fix the compilation errors without much difficulty, but I was defeated for a while by a group of test failures.

The package deals with 2D and 3D geometry, and has to check for various degenerate runtime conditions such as collinear points. When these are detected, an exception is thrown via a call to `error` with a string identifying the class of problem[^1]. The tests then have to catch these exceptions to make sure that all of the possible runtime error conditions are being flagged correctly. However, the expected exceptions weren't being raised and so the tests were failing.

[^1]: Even though best practice nowadays is to define a custom exception type with constructors for each class of problem, it should still be possible to make this code work. It isn't my code, and I wanted to make just enough changes to get the code working with a modern toolchain so I could get on with using the package in my own application.

Effectively, the tests were doing this:

```haskell
result <- try . evaluate $ function args
assertBool "result" $ result == Left (ErrorCall err)
```

But the assertion didn't hold. What was going on here? And if the code used to work in the past, why wasn't it working now?

I'm continually thankful to be working in a language that has a repl, so I opened up `ghci` and started trying out various examples. Eventually, I discovered this puzzling behaviour:

```haskell
λ> :m +Control.Exception
λ> r <- try $ error "boo!" :: IO (Either ErrorCall ())
λ> r == Left (ErrorCall "boo!")
False
λ> case r of { Left (ErrorCall "boo!") -> True; _ -> False; }
True
```

How could the equality fail when the pattern match succeeds?

The reason is that exceptions can have a "hidden" callstack attached, and that's included in the equality test:

```haskell
λ> s <- try $ error "boo!" :: IO (Either ErrorCall ())
λ> r == s
False
λ> r
Left boo!
CallStack (from HasCallStack):
  error, called at <interactive>:3:12 in interactive:Ghci1
λ> s
Left boo!
CallStack (from HasCallStack):
  error, called at <interactive>:15:12 in interactive:Ghci7
λ> Left (ErrorCall "boo!")
Left boo!
```

The exceptions thrown from different locations in the code have different callstacks, and the exception constructed manually has no callstack. They're all different from one another when compared using `==`.

However, the callstack doesn't participate in the pattern-matching, so all three exceptions succeed in matching the pattern.

I referred to the callstack as "hidden", and although functions can have implicit arguments constructors can't have implicit fields. So how can the callstack be "hidden"?

The answer, as my friend and colleague [Alexey Kuleshevich](https://github.com/lehins) pointed out, is that `ErrorCall` is actually a `pattern` synonym and the underlying constructor is `ErrorCallWithLocation`:

```haskell
-- | The first @String@ is the argument given to 'error', and the second @String@ is the location.
data ErrorCall = ErrorCallWithLocation String String

pattern ErrorCall :: String -> ErrorCall
pattern ErrorCall err <- ErrorCallWithLocation err _ where
  ErrorCall err = ErrorCallWithLocation err ""
```

This was introduced with GHC **8** and stayed that way through GHC **9.10**. It was then changed back to the original form with GHC **9.12** when the backtrace exception mechanism was introduced (and `ErrorCallWithLocation` became the pattern).

Unfortunately, I had been looking at the Haddocks for GHC 9.12 (even though I wasn't using 9.12) and so missed the entire period during which `ErrorCall` was a pattern synonym!

As Alexey put it,

> … the comparison approach that relies on `Eq` would work up to and including `ghc-7.10`, because there
> was no callstack on `error` back then, and would start working again with `ghc-9.12`, since callstacks are now handled differently.

This was an interesting journey, and it reinforced the importance of a number of best practices:

1. Make sure you use Haddocks that match the dependency versions you're using.

1. Do all you can to insulate your application from the implementation details of your dependencies.

1. Always remember that what looks like a constructor may in fact be a pattern.

1. Try to avoid using equality tests on exceptions and use pattern matches instead.

1. Use a custom exception type to communicate client errors.

   And, to answer the question asked in the title of this post,

1. Remember that a manually-created exception value may not actually be an exception at all!
