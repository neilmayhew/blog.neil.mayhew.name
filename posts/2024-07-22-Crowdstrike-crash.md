---
layout: post
title: Jumping to Conclusions
date: 2024-07-22 23:06:05 -06:00
---
Attributing the [Crowdstrike crash][1] to a "null pointer error" turns out to have been a little simplistic[^1].

The update didn't include any code changes, only data changes[^2]. So it wasn't a simple coding error that wasn't caught in review. This code has been running successfully for a while.

The code reads the data files (aka "channel files") and stores the data in memory. It then uses the in-memory data as pointers later on. The code that stores the pointers checks for zeros, but not for small values. This was not a field offset from a null pointer to a structure, but a genuine small-but-non-null pointer.

It's true that Rust makes it much harder to have bad pointers, but since this one came from a data file Rust wouldn't have helped. It would in fact be necessary to use an `unsafe` Rust block to do what the current C++ code does, so would be susceptible to exactly the same problem. You could argue that it must be a bad algorithm to require unsafe code, but given what this software does (monitor the system at a deep level for suspicious behaviour) it needs to be able to use arbitrary pointers, which is inherently unsafe.

Regarding this problem going undetected in testing, one line of investigation suggests that the bad data causes the code to use uninitialized memory at some point, and that the problem would manifest differently on different systems. It could well be that it simply never manifested on Crowdstrike's test systems.

My takeaway from this is to be a little slower to make assumptions, and be careful not to make or repeat uninformed judgements, when fellow software developers are concerned. After all, it could be us on the other end of that one day.

[1]: https://en.wikipedia.org/wiki/2024_CrowdStrike-related_IT_outages

[^1]: [Tweet from Tavis Ormandy](https://x.com/taviso/status/1814762302337654829)
[^2]: [Technical Details: Falcon Content Update for Windows Hosts](https://www.crowdstrike.com/en-us/blog/falcon-update-for-windows-hosts-technical-details/)
