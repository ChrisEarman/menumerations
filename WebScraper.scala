package menumerations
import scala.io.Source
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Await
import scala.concurrent._

object WebScraper {

  def downloadRecipeFile(recipeNum: Int): String = {
    val html = Source.fromURL("http://www.food.com/hello-" + recipeNum, "UTF-8")
    val s = html.mkString
    return s
  }

  def parseRecipeFile(recipeStr: String): Recipe = {
    return new Recipe(null, null)
  }
  
  def storeRecipe(recipe: Recipe) = {
    
  }
  
  def main(args: Array[String]) {

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
        storeRecipe(recipe)
      } catch {
        case e: Exception => ;
      }
    }

    /**
     *  Sequences the above tasks
     */
    val aggregated: Future[Seq[Unit]] = Future.sequence(tasks)

    /**
     *  Waits for all recipes to finish downloading, or until
     *  4 hours have passed.
     */
    val res: Seq[Unit] = Await.result(aggregated, 4.hours)
  }
}