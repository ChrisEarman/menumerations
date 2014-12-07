package menumerations

/**
 *  An object representing an entire recipe.
 *  Fields are:
 *  - ingredients:  the set of [Ingredient] objects found in the recipe
 *  - instructions: the list of [Instruction] objects found in the recipe,
 *  				ordered as specified by the recipe
 *  - id:			the numerical id of the recipe, as found on food.com
 */
case class Recipe(ingredients: Set[Ingredient], instructions: Seq[Instruction], id: Int) {

}