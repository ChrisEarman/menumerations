Require Import String.

(**
 *  A (string, string, string, string, int) type, where
 *  the first four strings represent the strings in the
 *  4-tuple and the int represents the recipe in which
 *  the 4-tuple was found.
 *)
Inductive tuple4: Set :=
  quadruple: string -> string -> string -> string -> nat -> tuple4.

(**
 *  A record type for a 4-gram graph.  The underlying
 *  implementation is simply a list of 4-tuples.
 *)
Record four_gram_graph: Set := mk_graph {
  expose_list: list tuple4
}.

(**
 *  A function for determining if two strings are
 *  equivalent.  If s1 prefixes s2, and s2 prefixes
 *  s1, they must be equivalent.
 *)
Definition str_eq (s1 s2: string): bool :=
  andb (prefix s1 s2) (prefix s2 s1).

(**
 *  A function that is given t, a [tuple4], and lst, a
 *  list of [tuple4], and returns the members of lst
 *  that are adjacent to t.
 *  Adjacency in a four_gram_graph is defined as follows:
 *    t2 is adjacent to t1 iff the last three elements of
 *    t1 are equal to the first three elements of t2.
 *  That is, t2 is adjacent to t1 iff
 *    t2 = (a, b, c, _) and t1 = (_, a, b, c).
 *)
Fixpoint getAdjacent (t1: tuple4) (lst: list tuple4): list tuple4 :=
  match lst with
    | cons h t =>
      match h with
        | quadruple a b c _ _ =>
          match t1 with
            | quadruple _ d e f _ =>
              if (andb (str_eq a d) (andb (str_eq b e) (str_eq c f)))
                  then cons h (getAdjacent t1 t)
                  else getAdjacent t1 t
          end
      end
    | nil => nil
  end.