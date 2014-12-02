package menumerations

/**
 *  An object representing an ingredient in a recipe.
 *  Fields are:
 *  - text:   the 'name' of an ingredient
 *  - amount: how much of an ingredient is called for 
 *  		  (see [Amount] class for more details)
 *      
 *  (NOTE: more fields will likely be added in the future.)
 */
case class Ingredient(text: String, amount: Amount) {

}