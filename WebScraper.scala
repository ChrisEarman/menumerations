package menumerations

import scala.collection.immutable._
import scala.concurrent._
import scala.concurrent.Await
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._
import scala.io.Source
import reactivemongo.api._
import reactivemongo.bson._
import reactivemongo.api.collections.default._

object WebScraper {

  /**
   *  Returns a string consisting of the entire contents of the HTML file associated
   *  with the given recipe number.  All recipes on food.com are given a numerical
   *  ID, ranging from ~40 to ~519809 (as of Dec 1, 2014).  As new recipes are added,
   *  they are assigned the next available ID.
   */
  def downloadRecipeFile(recipeNum: Int): String = {
    val html = Source.fromURL("http://www.food.com/" + recipeNum + "-" + recipeNum, "UTF-8")
    val s = html.mkString
    return s
  }

  /**
   *  Returns a [Recipe] object from the given string.  This string represents the
   *  contents of a food.com recipe HTML file.
   *
   *  The current implementation will be replaced by code extracted from Coq.
   */
  def parseRecipeFile(recipeStr: String, recipeId: Int): Recipe = {
    val ingredients = getIngredients(recipeStr: String)
    val instructions = getInstructions(recipeStr: String)
    if (!ingredients.isEmpty && !instructions.isEmpty) {
      return new Recipe(ingredients, instructions, recipeId)
    } else {
      return null
    }
  }

  def getIngredients(recipeStr: String): Set[Ingredient] = {
    val start = recipeStr.indexOfSlice("<span class=\"name\">") + 19
    if (start == 18) {
      return Set()
    } else {
      val end = recipeStr.indexOfSlice("</span>", start)
      val tail = recipeStr.slice(end + 7, recipeStr.length())
      val slice = removeTags(recipeStr.slice(start, end)).split("\\s+").tail.mkString(" ")
      return getIngredients(tail) + Ingredient(slice, null)
    }
  }

  def getInstructions(recipeStr: String): Seq[Instruction] = {
    val start = recipeStr.indexOfSlice("<div class=\"txt\">") + 17
    if (start == 16) {
      return Seq()
    } else {
      val end = recipeStr.indexOfSlice("</div>", start)
      val tail = recipeStr.slice(end + 6, recipeStr.length())
      val slice = recipeStr.slice(start, end)
      return Instruction(slice) +: getInstructions(tail)
    }
  }
  
  def removeTags(str: String): String = {
    val start = str.indexOfSlice("<")
    if (start == -1) {
      return str
    } else {
      val end = str.indexOfSlice(">", start)
      val tail = str.slice(end + 1, str.length())
      val head = str.slice(0, start)
      return head + removeTags(tail)
    }
  }

  /**
   *  Writer object for converting [Instruction] objects to BSON
   */
  implicit object InstructionWriter extends BSONDocumentWriter[Instruction] {
    def write(instruction: Instruction): BSONDocument = BSONDocument(
      "text" -> instruction.text)
  }

  /**
   *  Writer object for converting [Ingredient] objects to BSON
   */
  implicit object IngredientWriter extends BSONDocumentWriter[Ingredient] {
    def write(ingredient: Ingredient): BSONDocument = BSONDocument(
      "text" -> ingredient.text)
  }

  /**
   *  Writer object for converting [Recipe] objects to BSON
   */
  implicit object RecipeWriter extends BSONDocumentWriter[Recipe] {
    def write(recipe: Recipe): BSONDocument = BSONDocument(
      "_id" -> recipe.id,
      "ingredients" -> recipe.ingredients,
      "instructions" -> recipe.instructions)
  }

  /**
   *  Stores a [Recipe] object in a Mongo database by first converting it into a
   *  BSON document.
   */
  def storeRecipe(recipe: Recipe, collection: BSONCollection): Unit = {
    val recipeDoc = BSON.write(recipe)
    collection.insert(recipeDoc)
  }

  def run() = {
    val driver = new MongoDriver
    val connection = driver.connection(List("localhost"))
    val db = connection("menumerations")
    val recipeCollection = db("recipes")

    /**
     *  Create tasks for downloading the HTML file for each recipe on food.com.
     *  After downloading, the contents of each file are converted into a
     *  string, which is then passed to the HTML Parser component.
     *  The parser returns a [Set] of [Ingredient] objects and a
     *  [List] of [Instruction] objects, which will then be stored
     *  in a document corresponding to the recipe in a Mongo database.
     */
    val tasks: Seq[Future[Unit]] = for (i <- 1 to 519809) yield future {
      try {
        val recipeStr = downloadRecipeFile(i)
        val recipe = parseRecipeFile(recipeStr, i)
        println("Parsed recipe " + i)
        if (recipe != null) { //TODO: Use option type!
          storeRecipe(recipe, recipeCollection)
        }
      } catch {
        case e: Exception => ;
      }
    }

    /**
     *  Aggregates the above tasks
     */
    val aggregated: Future[Seq[Unit]] = Future.sequence(tasks)

    /**
     *  Waits for all recipes to finish downloading, or until
     *  4 hours have passed.
     */
    val res: Seq[Unit] = Await.result(aggregated, 4.hours)
  }

  def main(args: Array[String]) {
    run
  }
}