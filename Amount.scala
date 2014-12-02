package menumerations

/**
 *  An object representing the physical amount of an ingredient.
 *  Fields are:
 *  - quantity: the numerical value of the amount
 *  - measure:  the unit in which the amount is measured (cup, tbsp, etc.)
 */
case class Amount(quantity: Double, measure: String) {

}