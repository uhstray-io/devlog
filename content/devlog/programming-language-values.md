+++
date = '2026-01-16T15:57:56-05:00'
draft = true
title = 'Programming Language Values' 
tags = ['programming-language','values']
+++

##### In this post, we will explore the concept of programming language values, why they matter, and how to choose the right programming language based on your values as a developer. We will also explore how these values impact the development experience and the software we create, as well as the pitfalls of ignoring them.



A programming language is more than just a set of keywords and syntax. A language is a set of ideas and values. The language's core values are driven almost entirely by the community and its core team members. Therefore, when we are choosing a language, we are really choosing whether we want to be a part of that set of values and community. Inherently, the community will shape the language based on their values. 

Every language has values whether they are stated or not. Sometimes these values change over time as the community and core team change. When choosing a language, it is important to understand what those values are and how they align with your own values as a developer. 

Historically, older programming languages were created out of necessity, not values. It was only later that communities formed around these languages and began to shape their values. And that is why choosing the right programming language is so important. When we are choosing a language, we are choosing a set of values that will shape our development experience and the software we create. 

# Value Conflicts & Tradeoffs

Here is a table of some common values (adapted from Bryan Cantrill's talk):


| | | |
|------------------|-----------------|--------------|
| Approachability  | Integrity       | Robustness   |
| Availability     | Maintainability | Safety       |
| Compatibility    | Measurability   | Security     |
| Composability    | Operability     | Simplicity   |
| Debuggability    | Performance     | Stability    |
| Expressiveness   | Portability     | Thoroughness |
| Extensibility    | Resilience      | Transparency |
| Interoperability | Rigor           | Velocity     |


And here are some of the values associated with popular programming languages. This list is not exhaustive, but it gives a good idea of how different languages prioritize different values.

|Language  | Values |
|----------|--------|
|C         | Performance, Portability, Simplicity |
|C++       | Performance, Expressiveness, Compatibility |
|Elm       | Safety, Maintainability, Simplicity |
|Elixir    | Scalability, Maintainability, Resilience |
|Go        | Simplicity, Performance, Maintainability |
|Java      | Portability, Maintainability, Compatibility |
|Python    | Approachability, Expressiveness, Extensibility |
|Rust      | Safety, Performance, Robustness |
|JavaScript| Approachability, Extensibility, Interoperability |
|Haskell   | Rigor, Expressiveness, Purity |
|Zig       | Performance, Safety, Simplicity, Robustness |



# Real-World Consequences
## And choosing the right ones

The values embedded in a programming language have real consequences for the software we build. When a language prioritizes performance over safety, we see this play out in memory safetyissues like buffer overflows and memory corruption bugs that have plagued C and C++ codebases for decades. When a languages prioritizes approachability over rigor, we get flexible systems that can be quick to prototype but might be difficult to maintain at scale.

Consider the contrast between Python and Rust. Python's values of approachability and expressiveness make it an excellent choice for scripting, data analysis, and rapid prototyping. But those same values mean that type errors and runtime exceptions are discovered late, often in production. Rust's values of safety and robustness mean a steeper learning curve and longer compile times, but the compiler catches entire classes of bugs before the code ever runs.

Neither approach is wrong. The question is: what does your project need? A weekend hackathon project has different requirements than flight control software. Your startup company has different needs compared to a bank processing financial transaction system.

The mistake is not in choosing one set of values over another. The mistake is in not recognizing that you are making a choice at all.




# When Values Evolve

Languages are not static. As communities grow and leadership changes, so do the values that guide a language's development. This can be a source of tension.

JavaScript is perhaps the most dramatic example. What started as a hastily designed scripting language for web browsers has evolved into a sprawling ecosystem with TypeScript adding static typing, and tooling that competes with compiled languages. The community's values shifted from "just make it work" and to "make it maintainable at scale." Not to say that this shift was without its growing pains, but it showscases how a language's values and priorities evolve over time.



Python's transition from Python 2 to Python 3 revealed a value shift toward consistency and correctness, even at the cost of breaking compatibility. The years-long migration pain was a direct consequence of the community deciding that long-term maintainability mattered more than short-term convenience.

Any widely used programming language's values will evolve own given enough time.  And that is why it is important to pick a language whose current values align as close as possible with your own. 

# My Personal Values

My values are centered around performance, safety, robustness, and simplicity. These come from years of debugging production systems, chasing down broken packages, building robust systems, and maintaining code that will outlive me. 

## Why These Values Matter to Me
Performance matters because users notice latency. Safety matters because bugs in production cost time, money, and trust. Robustness matters because systems fail, and when they do, they should fail gracefully. Simplicity matters because code is read far more often than it is written, and complexity is the enemy of understanding.

This is why I find myself drawn to languages like Zig and Rust and Go. They take these values seriously, embedding them into the language itself rather than leaving them as optional best practices.





---

## References

Bryan Cantrill has given several excellent talks on this topic that heavily influenced my thinking:

- [Platform as a Reflection of Values](https://www.youtube.com/watch?v=Xhx970_JKX4)
- [The Summer of Rust](https://www.youtube.com/watch?v=YKv_IDN0zCA)