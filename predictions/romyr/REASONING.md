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

Facts are tried top to bottom. parent(tom, liz) comes before parent(tom, bob), and no other fact has tom first.

## P02

No variables, so a match prints true. Only one fact matches, so there is no second answer.

## P03

No fact has tom as the child, so nothing matches.

## P04

X binds to f(Y, a), then Y binds to b. X contains that same Y, so X prints as f(b,a). Unification succeeds only one way.

## P05

Same functor and arity, so the arguments match one by one: X=a and b=Y. Only one way to match.

## P06

Two different atoms never unify.

## P07

parent(tom, P) tries liz first, but liz has no children. Then bob, whose children are ann, then pat.

## P08

The base clause comes first, so tom's children (liz, bob) come out first. Recursion through bob then adds ann, pat, sue, jim.

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

