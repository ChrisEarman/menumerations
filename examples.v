Require Import String.
Require Import Ascii.

Local Open Scope string_scope.

Example BourbanChicken := "
<span class=""item"">
                        <h1 class=""fn""  itemprop=""name"">Bourbon Chicken</h1>
                    </span>

                    <div class=""recipe-user"">
                        <a href=""http://share.food.com/community/LinMarie/style.esi?member_id=58278""><img src=""http://share.recipezaar.com/skins/main/images/profilephotolookup/21_square.gif"" alt="""" width=""48"" height=""48"" /></a>

                        <div class=""user-info clrfix"">

                            <div class=""usernameflyout clrfix"">
                                <p class=""un"">
                                        By
                                    <span class=""author "">
                                        <a class=""url fn"" href=""http://share.food.com/community/LinMarie/style.esi?member_id=58278""><span itemprop=""author"">LinMarie</span></a>
                                    </span>
                                </p>
                                
                        <ul>
                            <li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">2 </span> <span class=""type"">lbs</span></span> 
                            <span class=""name"">
                             
                            
                                <a href=""http://www.food.com/library/chicken-221"">boneless chicken breasts</a>, cut into bite-size pieces
                            
                            
                            </span>
                            
                            </span>
                            </li>
                            
                            <li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">1 -2 </span> <span class=""type"">tablespoon</span></span> 
                            <span class=""name"">
                             
                            
                                <a href=""http://www.food.com/library/olive-oil-495"">olive oil</a>
                            
                            
                            </span>
                            
                            </span>
                            </li>
                            
                            <li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">1 </span> <span class=""type""></span></span> 
                            <span class=""name"">
                             
                            
                                <a href=""http://www.food.com/library/garlic-165"">garlic clove</a>, crushed
                            
                            
                            </span>
                            
                            </span>
                            </li>
                            
                            <li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">1/4</span> <span class=""type"">teaspoon</span></span> 
                            <span class=""name"">
                             
                            
                                <a href=""http://www.food.com/library/ginger-166"">ginger</a>
                            
                            
                            </span>
                            
                            </span>
                            </li>
                            
                            <li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">3/4</span> <span class=""type"">teaspoon</span></span> 
                            <span class=""name"">
                             
                            
                                <a href=""http://www.food.com/library/red-pepper-flakes-507"">crushed red pepper flakes</a>
                            
                            
                            </span>
                            
                            </span>
                            </li>
                            
                            <li class=""ingredient""  itemprop=""ingredients"">
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
                            </li>
                            
                            <li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">2 </span> <span class=""type"">tablespoons</span></span> 
                            <span class=""name"">
                             
                            
                                <a href=""http://www.food.com/library/ketchup-156"">ketchup</a>
                            
                            
                            </span>
                            
                            </span>
                            </li>
                            
                            <li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">1 </span> <span class=""type"">tablespoon</span></span> 
                            <span class=""name"">
                             
                            
                                <a href=""http://www.food.com/library/cider-vinegar-525"">cider vinegar</a>
                            
                            
                            </span>
                            
                            </span>
                            </li>
                            
                            <li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">1/2</span> <span class=""type"">cup</span></span> 
                            <span class=""name"">
                             
                            
                                <a href=""http://www.food.com/library/water-459"">water</a>
                            
                            
                            </span>
                            
                            </span>
                            </li>
                            
                            <li class=""ingredient""  itemprop=""ingredients"">
                            <span class=""ingredient""><span class=""amount""><span class=""value"">1/3</span> <span class=""type"">cup</span></span> 
                            <span class=""name"">
                             
                            
                                <a href=""http://www.food.com/library/soy-sauce-473"">soy sauce</a>
                            
                            
                            </span>
                            
                            </span>
                            </li>
                            
            </ul>


<div class=""pod directions"">
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