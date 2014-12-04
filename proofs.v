Require Import html_parser.
Require Import String.

(*
   Proof: If the nameIndex of any string returns 0 
          (indicating that no name was found) then
          getName should return the EmptyString.
*)

Theorem noNameIndex: 
        forall s: string, 
        getNameIndex s = 0 -> getName s = EmptyString.
Proof.
  intros.
  unfold getName.
  rewrite -> H.
  compute.
  reflexivity.
Qed.

