Require Import String.
Require Import Ascii.

Local Open Scope string_scope.


Example Space := " ".

Example HelloWorld: string := " ""Hello world!"" ".

Print HelloWorld.

Require Import Arith.

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


Fixpoint validPrefix (prefix s : string): bool :=
 true. 

Fixpoint indexOfSubstring (sub s: string) (curIndex: nat): nat :=
1.

Definition getNameIndex (s: string): nat :=
  let x := "itemprop=""name""" in
  indexOfSubstring s x 0.

Compute getNameIndex "sup" 1 1.
Compute getNameIndex "sup" 1 3.