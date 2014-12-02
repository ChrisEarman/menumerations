package menumerations
import scala.io.Source
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Await
import scala.concurrent._
//import reactivemongo.api._
//import reactivemongo.bson._

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
   */
  def parseRecipeFile(recipeStr: String): Recipe = {
    return new Recipe(null, null, 0)
  }

  /**
   *  Stores a [Recipe] object in a Mongo database by first converting it into a
   *  BSON document.
   */
//  def storeRecipe(recipe: Recipe, collection: BSONCollection) = {
//
//  }

  def main(args: Array[String]) {

//    val driver = new MongoDriver
//    val connection = driver.connection(List("localhost"))
//    val db = connection("menumerations")
//    val recipeCollection = db("recipes")

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
        val recipe = parseRecipeFile(recipeStr)
//        storeRecipe(recipe, recipeCollection)
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
}