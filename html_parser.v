Require Import String.
Require Import Ascii.
Require Import Arith.
Require Import additional_tools.

Local Open Scope string_scope.

(* I initially planeed on making my own function for this
   but then I realized that the function exists in the String library
*)
(* Fixpoint validPrefix (pre s : string): bool :=
 prefix pre s. *)

(* 
   This function takes in two strings, sub and s.
   it looks to see if sub is a substring of s,
   if sub is a substring of s then it returns the
   index of the substring otherwise it will return 
   the length of the string s.

   This function ASSUMES that sub is not a the EmptyString,
     if sub is the EmptyString then length s will be the 
     desired ansewer.
*)
Fixpoint indexOfSubstring (sub s: string): nat :=
  if (prefix sub s)
  then 0
  else match s with
         | EmptyString => 0
         | String a s' => S (indexOfSubstring sub s')
       end.

(*
   This function takes in a string, s, and returns
   the index of the name of the recipe. If s has no
   recognizable name, then the function will return 0.
*)
Definition getNameIndex (s: string): nat :=
  let x := "itemprop=""name"">" in
    let index := indexOfSubstring x s in
      if (beq_nat index (length s))
      then 0 
      else plus index 16 
(*16 is the lenth of x, thus the name starts 16 spaces from the begining of x*).


(*
    This function takes in a string, s, and returns
    the index of the first "<" character. The function
    will return the length of the string s if there is 
    no instance of the character "<".
*)
Fixpoint getEndIndex (s: string): nat := 
  match s with
    | EmptyString => 0
    | String a s' => if (beq_ascii a "<")
                     then 0
                     else S (getEndIndex s')
  end.

(*
    This function takes in a string, s, and returns
    the length of the name in the string s.
*)
Definition getNameLength (s: string): nat := 
  let startIndex := getNameIndex s in
    let post := substring startIndex ((length s) - startIndex) s in 
      getEndIndex post.

(*
    This function takes in a string, s, and returns
    the name held within that string. If no name exists
    within the string then it returns the EmptyString.
*)
Definition getName (s: string): string :=
  substring (getNameIndex s) (getNameLength s) s.







(*
   -------------
   ----Tests----
   -------------
*)
Compute getNameIndex "sup". (*Should return 0*)
Compute prefix "bob" "bobby". (*returns true*)
Compute prefix "bobby" "bob". (*returns false*)

Example bChicken : string := "<h1 class=""fn"" itemprop=""name"">Bourbon Chicken</h1>".
Example ssfChicken : string := 
        "<div class=""leady-hd rz-rec clrfix"">
            <span class=""item"">
                <h1 class=""fn"" itemprop=""name"">Savory Southern Fried Chicken</h1>
            </span>
            ...
        </div>".
Compute getNameIndex bChicken. (*should return 31*)
Compute getNameLength bChicken. (*should return 15*)
Compute getName bChicken. (*should return Bourbon Chicken*)
Compute getName ssfChicken. (*should return Savory Southern Fried Chicken*)