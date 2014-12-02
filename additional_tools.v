Require Import String.
Require Import Ascii.
Require Import Arith.


Definition ascii2nat (a : ascii) :=
  match a with
  | Ascii a1 a2 a3 a4 a5 a6 a7 a8 =>
      2 *
      (2 *
       (2 *
        (2 *
         (2 *
          (2 *
           (2 * (if a8 then 1 else 0)
            + (if a7 then 1 else 0))
           + (if a6 then 1 else 0))
          + (if a5 then 1 else 0))
         + (if a4 then 1 else 0))
        + (if a3 then 1 else 0))
       + (if a2 then 1 else 0))
      + (if a1 then 1 else 0)
  end.
Print ascii2nat.
Definition beq_ascii (a1 a2: ascii) : bool :=
  beq_nat (ascii2nat a1) (ascii2nat a2).

(*
    This function takes in an option ascii, oA, 
    and returns that ascoo. If the option is 
    None then it returns a default value. This 
    function should not be used to evaluation
    Some "000".
*)
Local Open Scope char_scope.
Definition option2ascii (oA: option ascii): ascii :=
  match oA with
    | None => "000"
    | Some a => a
  end.


(* These functions are not included in Arith for some reason,
   I initially had use for them but I no longer do,
   I am leaving them here on the off chance that they may be usefull later on
*)
Fixpoint ble_nat (n m : nat) : bool :=
  match n with
  | O => true
  | S n' =>
      match m with
      | O => false
      | S m' => ble_nat n' m'
      end
  end.

Definition blt_nat (n m : nat) : bool :=
  match ble_nat n m with
    | true => negb (beq_nat n m)        
    | false => false
  end.