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
    This function takes in a string, s, and
    returns the string with trailing white
    space removed.

    White space is definied as either a 'space'
    or a 'new line'
*)
Fixpoint removeTrailingWhiteSpace (s: string) (n: nat): string := 
  let lastChar := option2ascii (get n s) in
    match n with
      | 0 => EmptyString
      | S n' => if (beq_ascii lastChar " ")
                then removeTrailingWhiteSpace (substring 0 n s) n'
                else if (beq_ascii lastChar "
")
                     then removeTrailingWhiteSpace (substring 0 n s) n'
                     else s
    end.



(*
    This function takes in a string, s, and
    returns the string with leading white
    space removed.

    White space is definied as either a 'space'
    or a 'new line'
*)
Fixpoint removeLeadingWhiteSpace (s: string): string := 
  match s with
    | String " " s1 => removeLeadingWhiteSpace s1
    | String "
" s2 => removeLeadingWhiteSpace s2
    | s' => s'
  end.

(*
    This function takes in a string, s, and
    returns the string with leading and trailing
    white space removed.

    White space is defined as either a 'space'
    or a 'new line'.
*)
Definition trimWhiteSpace (s: string): string :=
  removeLeadingWhiteSpace (removeTrailingWhiteSpace s ((length s) - 1)).


(* ------ tests -------- *)
Compute prefix "bob" "bobby". (*returns true*)
Compute prefix "bobby" "bob". (*returns false*)
Compute removeLeadingWhiteSpace " 
  sup". (* should return "sup"*)
Compute option2ascii (get 2 "sup"). (*should return "p"*)
Compute removeTrailingWhiteSpace "sup  
  " 7. (*should return "sup"*)
Compute trimWhiteSpace "  
 sup 
 ". (*should return "sup"*)

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
      indexOfSubstring "<" post.

(*
    This function takes in a string, s, and returns
    the name held within that string. If no name exists
    within the string then it returns the EmptyString.
*)
Definition getName (s: string): string :=
  let start_index := getNameIndex s in
    let name_length := getNameLength s in
      if (beq_nat start_index 0)
      then EmptyString
      else trimWhiteSpace (substring start_index name_length s).

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
Compute getName "sup<". (*should be EmptyString*)


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
    the first instance of a close tag of type </a>
    or of type </span>. This helps us to find the 
    end index of an ingredient.
*)
Definition getIngredientEndIndex (s: string): nat :=
  let candidate_a := indexOfSubstring "</a>" s in
    let candidate_span := indexOfSubstring "</span>" s in
      if (blt_nat candidate_a candidate_span)
      then candidate_a
      else candidate_span.

(*
   This function takes in a string, s, and 
   returns true if the first instance of an
   </a> close tag in s appears before the 
   first instance of a </span> close tag
   in s. This is used to determine if a 
   given ingredient includes a link or not   
*)
Definition includesLink (s: string): bool :=
  let candidate_a := indexOfSubstring "</a>" s in
    let end_index := getIngredientEndIndex s in
      if (beq_nat candidate_a end_index)
      then true
      else false.

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
    let start_index := if (includesLink post)
                       then (indexOfSubstring ">" post) + 1 
                       else 0 
                       in 
      let end_index := getIngredientEndIndex post in
        let ingredient_length := end_index - start_index in
          trimWhiteSpace (substring start_index ingredient_length post).

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
          | s' => let start_index := (indexOfSubstring s' s) + (length s') in
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
Compute getIngredientIndex ssfChicken2. (*should return 285*)
Compute getIngredientIndex "sup". (*should return 0*)
Compute getPostIngredientSpan ssfChicken2. (*should start with "<a href=..." and include both cold water and fine sea salt*) 
Compute getPostIngredientSpan "sup". (*should return the EmptyString*)
Compute getNextIngredient ssfChicken2. (*should return "cold water"*)
Compute getNextIngredient "sup". (*should return the EmptyString*)
Compute getIngredients ssfChicken2. (*should return ["cold water"; "fine sea salt"; nil]*)
Compute getIngredients "sup</a>". (*should return [nil]*)
Example bChicken2: string := "<li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">1/4</span> <span class=""type"">cup</span></span> 
                            <span class=""name"">
                            apple juice
                            </span>
                            </span>
                            </li>
                            <li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">1/3</span> <span class=""type"">cup</span></span> 
                            <span class=""name"">
                                <a href=""http://www.food.com/library/brown-sugar-375"">light brown sugar</a>
                            </span>
                            </span>
                            </li>".
Compute getNextIngredient bChicken2. (*should be "apple juice", however leading and trailing whitespace is included*)
Compute getIngredients bChicken2. (*should be [apple juice; light brown sugar; nil], however it includes additional leading whitespace*)


(* -------------------------------
   ------Recipe Instructions------
   -------------------------------*)

(*
   This function takes in a string, s, and returns
   the index of the first instruction of the recipe.
   If s has no recognizable instructions, then the
   function will return 0.
*)
Definition getInstructionIndex (s: string): nat := 
  let x := "div class=""txt"">" in
    let index := indexOfSubstring x s in
      if (beq_nat index (length s))
      then 0
      else index + 16
(*16 is the length of x, thus the ingredient starts 16 spaces from the begining of x*).

(*
    This function takes in a string, s, and returns
    the length of the first instruction in the string s.
*)
Definition getInstructionLength (s: string): nat :=
  let start_index := getInstructionIndex s in
    let post_length := (length s) - start_index in
      let post := substring start_index post_length s in
        indexOfSubstring "</div>" post.

(*
    This function takes in a string, s, and returns
    the first instance of an instruction.
    
    If no instruction is found it will return the 
    EmptyString.

    This function assumes all instructions have 
    associated <div></div> tags as wrappers
*)
Definition getNextInstruction (s: string): string :=
  let start_index := getInstructionIndex s in
    let instruction_length := getInstructionLength s in
      let instruction := substring start_index instruction_length s in
        if (beq_nat start_index 0)
        then EmptyString
        else trimWhiteSpace instruction.
(*
    This function takes in a string, s, and a nat, n,
    and returns the list of instructions. This function
    uses n as its decreasing argument for a proof of
    termination. n should be the length of the string
    it is assumed that n is greater than or equal to
    the number of instructions in s.
*)
Fixpoint getInstructionsInternal (s: string) (n: nat): list string := 
  match n with
    | 0 => nil
    | S n' => match getNextInstruction s with
                | EmptyString => nil
                | s' => let start_index := (indexOfSubstring s' s) + (length s') in
                          let post_length := (length s) - start_index in
                            let post := substring start_index post_length s in
                              cons s' (getInstructionsInternal post n')
              end
  end.

(*
    This function takes in a string, s, and returns
    the list of instructions found within s. if no
    ingredients are present in s, then it returns
    the empty list, nil.
*)
Definition getInstructions (s: string): list string := 
  getInstructionsInternal s (length s).


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
</div>".

Compute getInstructions ssfChicken3. (*should return ["Editor's Note:...";...;"...and ENJOY.";nil]*)
Compute getInstructions "sup</div>". (*should return [nil]*)
