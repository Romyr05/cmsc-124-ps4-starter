<!--no-pdf-->
# Why Each Prediction Reads the Way It Does

Write one entry per case, before you run anything. Name the rule behind each
predicted field. One to three sentences is enough. The grader checks the
structure of this file only. It does not judge how good the reasoning is, and
it sets no word minimum.

For every case you predicted wrongly, add a short correction after you run
it: what you predicted, what the language printed, and which rule you
misread. Corrections belong in the correction commits, not the prediction
commit.

Commit this file together with `predictions.tsv`, before any case runs:

```bash
git add predictions.tsv REASONING.md
```

The example below uses a query that is not one of the 16 cases, so it gives
no answer away. `parent(pat, X)` reads `parent(pat, jim)` because the `parent`
facts are tried top to bottom and only that one has `pat` as its first
argument:

```text
## parent(pat, X)

The goal scans the parent facts in source order. Only parent(pat, jim) has
pat first, so X binds to jim. No second fact matches, so the first ; finds
nothing and the search ends after one answer.
```


## P01

The `parent` facts are tried from top to bottom. `parent(tom, liz)` gives the first answer and `parent(tom, bob)` gives the second, so there are 2 answers.

## P02

`parent(tom, bob)` directly matches the second parent fact, so the query succeeds once. There are no more matching facts.

## P03

No `parent` fact has `tom` as its second argument. The query therefore fails and has no answers.

## P04

`X = f(Y, a)` makes `X` the term `f(Y,a)`, then `Y = b` binds `Y` to `b`. Therefore `X` becomes `f(b,a)`.

**Correction:** Predicted `X=f(b,a)`. Prolog printed `X=f(b,a),Y=b`. I forgot that Prolog reports every variable in the query, so `Y=b` is part of the answer too.

## P05

The two `f` terms unify by matching their arguments. This gives `X = a` and `Y = b`, producing one answer.

## P06

The atoms `a` and `b` are different, so they cannot unify. The query fails.

## P07

The `grandparent` rule first finds Tom's children. `liz` has no children, so Prolog backtracks to `bob`, whose children are `ann` and `pat`. The answers are therefore `ann` and `pat`.

## P08

The base `ancestor` clause comes first, giving Tom's direct children `liz` and `bob`. The recursive clause then finds Bob's descendants `ann`, `pat`, `sue`, and `jim`, giving 6 answers in total.

## P09

The recursive clause comes first, so the deepest descendants come out first: sue, jim, then ann, pat, then liz, bob. Same 6 answers.

## P10

The base clause gives pat. The recursive clause walks the parent facts in order and finds tom (through bob, pat), then bob (through pat).

## P11

Left recursion: the first clause calls reach again before reading any edge, so it never produces an answer.

## P12

Reads an edge first, so it reaches d via a, b, c. Backtracking goes around the a-b-c cycle and finds true again, forever.

## P13

len counts back up from len([], 0): 1, 2, 3. Only one clause fits each list, so there is one answer.

## P14

With only the result known, join lists every split of [1,2] into front and back: []+[1,2], [1]+[2], [1,2]+[].

## P15

X > 2 runs first while X is unbound, so arithmetic throws an instantiation error.

## P16

elem binds X to 1, 2, 3 before the test runs, and only 3 passes X > 2.
