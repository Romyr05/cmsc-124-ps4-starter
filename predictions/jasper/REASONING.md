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

## P05

The two `f` terms unify by matching their arguments. This gives `X = a` and `Y = b`, producing one answer.

## P06

The atoms `a` and `b` are different, so they cannot unify. The query fails.

## P07

The `grandparent` rule first finds Tom's children. `liz` has no children, so Prolog backtracks to `bob`, whose children are `ann` and `pat`. The answers are therefore `ann` and `pat`.

## P08

The base `ancestor` clause comes first, giving Tom's direct children `liz` and `bob`. The recursive clause then finds Bob's descendants `ann`, `pat`, `sue`, and `jim`, giving 6 answers in total.

## P09

The recursive `ancestor_r` clause comes before the base clause. It reaches the deeper descendants first, producing `sue` and `jim` before the direct and closer descendants `ann`, `pat`, `liz`, and `bob`.

## P10

The base `ancestor` clause first finds `pat` because `parent(pat, jim)` is a fact. The recursive clause then finds `tom` through `tom -> bob -> pat -> jim`, and `bob` through `bob -> pat -> jim`, giving 3 answers.

## P11

The first `reach` clause calls `reach(X,Z)` before reading any edge. Because the recursive clause comes first, the query keeps recursing without reaching the base `edge` clause, so the search is unbounded. The second result is also `unbounded` because the search never reaches another answer.

## P12

The base `reach_r` clause is tried first and eventually finds the path `a -> b -> c -> d`, so the first answer is `true`. Backtracking can find the same path again through the cycle `a -> b -> c -> a`, so the second answer is also `true` and the search is unbounded.

## P13

The `len` predicate recursively processes `[a,b,c]`. It reaches `len([],0)` and adds 1 for each element, giving `N = 3`.

## P14

The `join` predicate can split `[1,2]` into three ways: `X=[]` and `Y=[1,2]`, `X=[1]` and `Y=[2]`, or `X=[1,2]` and `Y=[]`. Therefore there are 3 answers.

## P15

The first goal is `X > 2`, but `X` is not yet bound to a number. Arithmetic comparison requires a numeric value, so the query produces an error. Trying to find another answer produces the same error.

## P16

`elem` is tried first and produces `X=1`, but `1 > 2` fails. Backtracking gives `X=2`, which also fails, and then `X=3`, which satisfies `3 > 2`. Therefore there is one answer: `X=3`.