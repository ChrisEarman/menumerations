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
Fixpoint getAdjacencyList_impl (t1: tuple4) (lst: list tuple4): list tuple4 :=
  match lst with
    | cons h t =>
      match h with
        | quadruple a b c _ _ =>
          match t1 with
            | quadruple _ d e f _ =>
              if (andb (str_eq a d) (andb (str_eq b e) (str_eq c f)))
                  then cons h (getAdjacencyList_impl t1 t)
                  else getAdjacencyList_impl t1 t
          end
      end
    | nil => nil
  end.

Definition getAdjacencyList (t1: tuple4) (g: four_gram_graph): list tuple4 :=
  getAdjacencyList_impl t1 (expose_list g).

Definition addTuple (t1: tuple4) (g: four_gram_graph): four_gram_graph :=
  mk_graph (cons t1 (expose_list g)).

Definition emptyGraph: four_gram_graph :=
  mk_graph nil.


Example ex1 := quadruple "add" "salt" "and" "vinegar" 1.
Example ex2 := quadruple "salt" "and" "vinegar" "potato" 1.
Example ex3 := quadruple "salt" "and" "vinegar" "chips" 2.
Example graph1 := addTuple ex1 emptyGraph.
Example graph2 := addTuple ex2 graph1.
Example graph3 := addTuple ex3 graph2.
Compute getAdjacencyList ex1 graph1.
Compute getAdjacencyList ex1 graph2.
Compute getAdjacencyList ex1 graph3.

