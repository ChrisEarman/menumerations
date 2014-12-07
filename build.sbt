name := "menumerations"

version := "0.1"

scalaVersion := "2.11.2"

resolvers += "Sonatype Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots/"

resolvers += "Typesafe repository releases" at "http://repo.typesafe.com/typesafe/releases/"

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "reactivemongo" % "0.11.0-SNAPSHOT"
)