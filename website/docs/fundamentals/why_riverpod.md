---
title: Why use Riverpod / FAQ
---

[Riverpod] is a state-management solution.  
As with all state-management solutions, it tries to simplify managing the state
of an application.

But that's fairly broad. Let's see why use [Riverpod] _specifically_.

## Why use a state-management package

Implementing basic state-management is not too difficult.

After all, we could just declare a [StreamController]/[ValueNotifier] as a global
variable, and listen to it inside our widgets with [StreamBuilder]/[ValueListenableBuilder].  
It's a one-liner, works out of the box in Flutter, and has most of the features
you need.

Implementing a very specific feature never really was an issue. The problem is different:

**Scaling**

A visualization of the benefits of using a package would be the following graph:

![velocity graph](/img/velocity_graph.svg)

As explained by this graph, over time it becomes more complex to modify a project
when not following good architectures.

There is also the fact that it is easier for new team members to learn how the
project works, because of the predictable behavior and online resources.

## How [Riverpod] contributes toward making your application scalable

Concretely, [Riverpod] has two goals:

- Simplify writing good code
- Prevent/Highlight bad code

with both goals being of equal importance.

The first goal, simplifying writing good code, doesn't need a justification.

## Simplify writing good code

[riverpod]: https://github.com/rrousselgit/river_pod
[streamcontroller]: https://api.flutter.dev/flutter/dart-async/StreamController-class.html
[streambuilder]: https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html
[valuenotifier]: https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html
[valuelistenablebuilder]: https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html
