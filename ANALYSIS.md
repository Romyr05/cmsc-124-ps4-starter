# The Search and the Stack

Replace this paragraph after your checks pass. Paste the output of `./trace`
for one case. Then answer three questions about it.

- Which of its lines push a frame onto Activity 15's runtime stack? Which
  lines pop one?
- What does a `Redo` line resume that a returned frame cannot?
- Why does swapping the two clauses of `reach/2` change whether the search
  ever answers, while swapping the two clauses of `ancestor/2` only changes
  the order of the answers?

## Q3: Clause order in `reach/2` and `ancestor/2`

In `ancestor/2`, swapping the clauses only reorders the answers. `./run P08`
starts with `X=liz, X=bob` and `./run P09` starts with `X=sue, X=jim`, but
both find 6 answers. That's because both versions call `parent/2` before
recursing, so each call goes one generation down a family tree that has no
cycles. Prolog searches the same finite tree either way. It just visits the
branches in a different order.

`reach/2` is different. `./run P11` never answers: first, second, and count
are all `unbounded`. The recursive clause comes first and calls `reach(X, Z)`
before it reads any edge, so `reach(a, Z)` just calls itself again. Every call
adds a new frame and nothing moves forward, so Prolog never gets to `edge/2`
or the base clause.

`./run P12` (`reach_r`) tries the base clause first and reads an edge before
recursing, so it answers `true` right away. Its count is still `unbounded`
because the cycle a -> b -> c -> a keeps giving new paths to `d`.

So clause order decides whether we get an answer at all. The cycle decides
whether the search ever ends.
