package menumerations
import scala.io.Source
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Await
import scala.concurrent._

object WebScraper {

  def main(args: Array[String]) {
    val tasks: Seq[Future[Unit]] = for (i <- 1 to 519809) yield future {
      try {
        val html = Source.fromURL("http://www.food.com/hello-" + i, "UTF-8")
        val s = html.mkString
        println(s + "END OF RECIPE " + i)
      } catch {
        case e: Exception => ;
      }
    }

    val aggregated: Future[Seq[Unit]] = Future.sequence(tasks)

    val res: Seq[Unit] = Await.result(aggregated, 4.hours)
  }
}