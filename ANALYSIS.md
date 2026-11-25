# The Search and the Stack

== trace P14 ==
Call: join(X,Y,[1,2])
Exit: join([],[1,2],[1,2])
answer 1: X=[],Y=[1,2]
Redo: join([],[1,2],[1,2])
  Call: join(_,Y,[2])
  Exit: join([],[2],[2])
Exit: join([1],[2],[1,2])
answer 2: X=[1],Y=[2]
Redo: join([1],[2],[1,2])
  Redo: join([],[2],[2])
    Call: join(_,Y,[])
    Exit: join([],[],[])
  Exit: join([2],[],[2])
Exit: join([1,2],[],[1,2])
answer 3: X=[1,2],Y=[]
Redo: join([1,2],[],[1,2])
  Redo: join([2],[],[2])
    Redo: join([],[],[])
    Fail: join(_,Y,[])
  Fail: join(_,Y,[2])
Fail: join(X,Y,[1,2])
== 3 answers ==


- Which of its lines push a frame onto Activity 15's runtime stack? Which
  lines pop one?

The frame pushes are shown by the `Call` lines. `Call: join(X,Y,[1,2])` pushes the first `join/3` frame, then `Call: join(_,Y,[2])` pushes another frame, and `Call: join(_,Y,[])` pushes the innermost frame. A frame is popped when its goal finishes, shown by an `Exit` or `Fail`. For example, `Exit: join([],[],[])` means the innermost frame has completed, while `Fail: join(_,Y,[])` shows that it eventually finishes unsuccessfully. The trace therefore shows the stack growing with each `Call` and shrinking when those calls exit or fail.

- What does a `Redo` line resume that a returned frame cannot?

A `Redo` line resumes a goal that already exited, and it still knows its choice point and remaining alternatives. For example, after `answer 1`, `Redo: join([],[1,2],[1,2])` allows Prolog to continue searching and produce `answer 2`. This happens again at `Redo: join([1],[2],[1,2])`, eventually producing `answer 3`. In Activity 15, when a returned frame was popped, its local variables and saved state were thrown away. The `Redo` trace shows that Prolog instead retains the choice-point information needed to continue trying alternatives, which is why the same `join` goal can be resumed after already returning an answer.

- Why does swapping the two clauses of `reach/2` change whether the search
  ever answers, while swapping the two clauses of `ancestor/2` only changes
  the order of the answers?

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
