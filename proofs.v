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

(*
   Proof: If the instructionIndex of any string returns 0 
          (indicating that no instruction was found) then
          getNextInstruction should return the EmptyString.
*)
Theorem noInstructionIndex:
        forall s: string,
        getInstructionIndex s = 0 -> getNextInstruction s = EmptyString.
Proof.
  intros.
  unfold getNextInstruction.
  rewrite -> H.
  compute.
  reflexivity.
Qed.
