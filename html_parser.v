Require Import String.
Require Import Ascii.

Local Open Scope string_scope.


Example Space := " ".

Example HelloWorld: string := " ""Hello world!"" ".

Print HelloWorld.

Require Import Arith.

Fixpoint getNameIndex (s: string) (index length: nat): nat :=
  if (beq_nat index length)
  then 0
  else 1.

Compute getNameIndex "sup" 1 1.
Compute getNameIndex "sup" 1 3.