Require Import String.
Require Import Ascii.
Require Import Arith.
Require Import additional_tools.


Local Open Scope string_scope.

(* -------------------------------
   ------Basics-------------------
   -------------------------------*)
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
    the index of the first character a. The function
    will return the length of the string s if there is 
    no instance of the character a.
*)
Fixpoint getEndIndex (s: string) (a: ascii): nat := 
  match s with
    | EmptyString => 0
    | String s1 s' => if (beq_ascii s1 a)
                      then 0
                      else S (getEndIndex s' a)
  end.

(* ------ tests -------- *)
Compute prefix "bob" "bobby". (*returns true*)
Compute prefix "bobby" "bob". (*returns false*)

(* -------------------------------
   ------Recipe Name--------------
   -------------------------------*)

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
    the length of the name in the string s.
*)
Definition getNameLength (s: string): nat := 
  let startIndex := getNameIndex s in
    let post := substring startIndex ((length s) - startIndex) s in 
      getEndIndex post "<".

(*
    This function takes in a string, s, and returns
    the name held within that string. If no name exists
    within the string then it returns the EmptyString.
*)
Definition getName (s: string): string :=
  substring (getNameIndex s) (getNameLength s) s.

(* ------ tests -------- *)
Compute getNameIndex "sup". (*Should return 0*)
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


(* -------------------------------
   ------Recipe Ingredients-------
   -------------------------------*)


(*
    This function takes in a string, s, and outputs
    the first index where an instance of an ingredient
    appears, the index which is returned is the index 
    after "<span class=""name"">" and thus has
    a minimum value of 25, thus, if no instance of
    the above string is found, then the function will
    output 0.
*)
Definition getIngredientIndex (s: string): nat:=
  let x := "<span class=""name"">" in
    let index := indexOfSubstring x s in
      if (beq_nat index (length s))
      then 0
      else plus index 19
(*19 is the length of x, thus the ingredient starts 19 spaces from the begining of x*).


(*
    This function takes in a string, s, and returns
    all characters in the string s that occur after
    the first instance of "<span class=""name"">"
    within that string. If no such instance exists
    it returns the empty string.
*)
Definition getPostIngredientSpan (s: string): string:=
  let start := getIngredientIndex s in
    let post_length := minus (length s) start in
      let output := substring start post_length s in
        if (beq_nat (length output) (length s))
        then EmptyString
        else output.


(*
    This function takes in a string, s, and returns
    the first instance of an ingredient.
    
    If no ingredient is found it will return the 
    EmptyString.

    This function assumes all ingredients have 
    associated <a></a> tags as wrappers
*)
Definition getNextIngredient (s: string): string:=
  let post := getPostIngredientSpan s in
    let start_index := (getEndIndex post ">") + 1 in 
      let end_index := indexOfSubstring "</a>" post in
        let ingredient_length := end_index - start_index in
          substring start_index ingredient_length post.

(*
    This function takes in a string, s, and a nat, n,
    and returns the list of ingredients. This function
    uses n as its decreasing argument for a proof of
    termination. n should be the length of the string
    it is assumed that n is greater than or equal to
    the number of ingredients in s.
*)
Fixpoint getIngredientsInternal (s: string) (n: nat): list string := (*n is used to show termination*)
  match n with
    | 0 => nil
    | S n' =>
        match getNextIngredient s with
          | EmptyString => nil
          | s' => let start_index := indexOfSubstring s' s in
                    let post_length := (length s) - start_index in
                      let post := substring start_index post_length s in
                        cons s' (getIngredientsInternal post n')
        end
  end.
(*
    This function takes in a string, s, and returns
    the list of ingredients found within s. if no
    ingredients are present in s, then it returns
    the empty list, nil.
*)
Definition getIngredients (s: string): list string :=
  getIngredientsInternal s (length s).


(* ------ tests -------- *)
Example ssfChicken2: string := 
        "<li class=""ingredient"" itemprop=""ingredients"">
            <span class=""ingredient"">
                <span class=""amount"">
                    <span class=""value"">2 </span>
                    <span class=""type"">quarts</span>
                </span>
                <span class=""name"">
                    <a href=""http://www.sitename.com/directory/subdirectory-12"">cold water</a>
                </span>
            </span>
        </li>
        <li class=""ingredient"" itemprop=""ingredients"">
            <span =""ingredient"">
                <span class=""amount"">
                    <span class=""value"">2 </span>
                    <span class=""type"">tablespoons</span>
                </span>
                <span class=""name"">
                    <a href=""http://www.sitename.com/directory/subdirectory-33"">fine sea salt</a>
                </span>
            </span>
        </li>".
Compute getIngredientIndex ssfChicken2. (*should return 84*)
Compute getIngredientIndex "sup". (*should return 0*)
Compute getPostIngredientSpan ssfChicken2. (*should start with "<a href=..." and include both cold water and fine sea salt*) 
Compute getPostIngredientSpan "sup". (*should return the EmptyString*)
Compute getNextIngredient ssfChicken2. (*should return "cold water"*)
Compute getNextIngredient "sup". (*should return the EmptyString*)
Compute getIngredients ssfChicken2. (*should return ["cold water"; "fine sea salt"; nil]*)
Compute getIngredients "sup". (*should return [nil]*)


(* -------------------------------
   ------Recipe Instructions------
   -------------------------------*)

Definition getInstructionIndex (s: string): nat := 0.


Definition getInstructionLength (s: string): nat := 0.

Definition getNextInstruction (s: string): string := EmptyString.


Fixpoint getInstructionsInternal (s: string) (n: nat): list string := nil.

Definition getInstructions (s: string): list string := nil.


Example ssfChicken3 := 
"<div class=""pod directions"">
	<h2>Directions:</h2>
	<span class=""instructions""  itemprop=""recipeInstructions"">
	<ol>
			<li><div class=""num"">1</div> <div class=""txt"">Editor's Note:  Named Bourbon Chicken because it was supposedly created by a Chinese cook who worked in a restaurant on Bourbon Street.</div></li>
			<li><div class=""num"">2</div> <div class=""txt"">Heat oil in a large skillet.</div></li>
			<li><div class=""num"">3</div> <div class=""txt"">Add chicken pieces and cook until lightly browned.</div></li>
			<li><div class=""num"">4</div> <div class=""txt"">Remove chicken.</div></li>
			<li><div class=""num"">5</div> <div class=""txt"">Add remaining ingredients, heating over medium Heat until well mixed and dissolved.</div></li>
			<li><div class=""num"">6</div> <div class=""txt"">Add chicken and bring to a hard boil.</div></li>
			<li><div class=""num"">7</div> <div class=""txt"">Reduce heat and simmer for 20 minutes.</div></li>
			<li><div class=""num"">8</div> <div class=""txt"">Serve over hot rice and ENJOY.</div></li>
	</ol>
	</span>		
</div>"


