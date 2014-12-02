package menumerations

import scala.util.Random
import scala.collection.mutable.HashMap

/**
 *  A frequency table, used to store the frequency of single
 *  ingredients paired with some number (likely 0-2) of ingredients
 *  already in the recipe.
 */
class FrequencyTable(ingsInRecipe: Set[String]) {
  var table: HashMap[String, Int] = new HashMap[String, Int]
  var size: Int = 0

  /**
   *  Add an item to the frequency table, updating its frequency
   *  and the table's size
   */
  def add(item: String) = {
    if (table.contains(item)) {
    	table += (item -> (table(item) + 1))
    	size += 1
    } else {
      table += (item -> 1)
      size += 1
    }
  }
  
  /**
   *  Get a random key from the frequency table with probability
   *  proportional to that key's frequency
   */
  def getRandom(): String = {
    val randy = new Random
    var randInt = randy.nextInt(size)
    for ((k, v) <- table) {
      randInt -= v
      if (randInt <= 0) {
    	  return k
      }
    }
    return null
  }
}