import sbt.Keys._
import sbt._

import scala.io.Source
import spray.json.{DefaultJsonProtocol, _}
import complete.DefaultParsers._

import scala.language.postfixOps
import gov.nasa.jpl.imce.sbt._
import gov.nasa.jpl.imce.sbt.ProjectHelper._
import java.io.File
import java.nio.file.Files

licenses in GlobalScope += "Apache-2.0" -> url("http://www.apache.org/licenses/LICENSE-2.0.html")

updateOptions := updateOptions.value.withCachedResolution(true)

shellPrompt in ThisBuild := { state => Project.extract(state).currentRef.project + "> " }

resolvers := {
  val previous = resolvers.value
  if (git.gitUncommittedChanges.value)
    Seq[Resolver](Resolver.mavenLocal) ++ previous
  else
    previous
}

lazy val mdInstallDirectory = SettingKey[File]("md-install-directory", "MagicDraw Installation Directory")

mdInstallDirectory in Global :=
  baseDirectory.value / "target" / "md.package"

lazy val testsInputsDir = SettingKey[File]("tests-inputs-dir", "Directory to scan for input *.json tests")

lazy val testsResultDir = SettingKey[File]("tests-result-dir", "Directory for the tests results to archive as the test resource artifact")

lazy val testsResultsSetupTask = taskKey[Unit]("Create the tests results directory")

lazy val mdJVMFlags = SettingKey[Seq[String]]("md-jvm-flags", "Extra JVM flags for running MD (e.g., debugging)")

lazy val setupFuseki = taskKey[File]("Location of the apache jena fuseki server extracted from dependencies")

lazy val setupTools = taskKey[File]("Location of the imce ontology tools directory extracted from dependencies")

lazy val setupOntologies = taskKey[File]("Location of the imce ontologies, either extracted from dependencies or symlinked")

lazy val artifactZipFile = taskKey[File]("Location of the zip artifact file")

lazy val setupProfileGenerator = taskKey[File]("Location of the profile generator directory extracted from dependencies")

lazy val packageProfiles = taskKey[File]("Location of the generated profiles")

lazy val imce_ontologies_workflow =
  Project("gov-nasa-jpl-imce-ontologies-analysis", file("."))
    .enablePlugins(AetherPlugin)
    .enablePlugins(GitVersioning)
    .enablePlugins(UniversalPlugin)
    .settings(
      resolvers += Resolver.bintrayRepo("tiwg", "org.omg.tiwg"),

      projectID := {
        val previous = projectID.value
        previous.extra(
          "artifact.kind" -> "analysis")
      },

      scalaVersion := "2.11.8",

        // disable automatic dependency on the Scala library
      autoScalaLibrary := false,

      // disable using the Scala version in output paths and artifacts
      crossPaths := false,

      publishMavenStyle := true,

      // do not include all repositories in the POM
      pomAllRepositories := false,

      // make sure no repositories show up in the POM file
      pomIncludeRepository := { _ => false },

      // disable publishing the main jar produced by `package`
      publishArtifact in(Compile, packageBin) := false,

      // disable publishing the main API jar
      publishArtifact in(Compile, packageDoc) := false,

      // disable publishing the main sources jar
      publishArtifact in(Compile, packageSrc) := false,

      // disable publishing the jar produced by `test:package`
      publishArtifact in(Test, packageBin) := false,

      // disable publishing the test API jar
      publishArtifact in(Test, packageDoc) := false,

      // disable publishing the test sources jar
      publishArtifact in(Test, packageSrc) := false,

      sourceGenerators in Compile := Seq(),

      managedSources in Compile := Seq(),

      libraryDependencies ++= Seq(
        "gov.nasa.jpl.imce"
          % "gov.nasa.jpl.imce.ontologies.tools"
          % "0.4.0"
          artifacts
          Artifact("gov.nasa.jpl.imce.ontologies.tools", "zip", "zip", "resource"),

        "gov.nasa.jpl.imce" %% "imce.third_party.jena_libraries"
          % "3.4.+"
          artifacts
          Artifact("imce.third_party.jena_libraries", "zip", "zip", "resource"),

        "org.apache.jena" % "apache-jena-fuseki" % "2.4.1"
          % "compile"
          artifacts
          Artifact("apache-jena-fuseki", "tar.gz", "tar.gz")
      ),

      setupTools := {

        val slog = streams.value.log

        val toolsDir = baseDirectory.value / "target" / "tools"

        if (toolsDir.exists()) {
          slog.warn(s"IMCE ontology tools already extracted in $toolsDir")
        }  else {
          IO.createDirectory(toolsDir)

          val tfilter: DependencyFilter = new DependencyFilter {
            def apply(c: String, m: ModuleID, a: Artifact): Boolean =
              a.extension == "zip" &&
                m.organization.startsWith("gov.nasa.jpl.imce") &&
                m.name.startsWith("gov.nasa.jpl.imce.ontologies.tools")
          }

          update.value
            .matching(tfilter)
            .headOption
            .fold[Unit] {
            slog.error("Cannot find the IMCE ontology tools resource zip!")
          } { zip =>
            IO.unzip(zip, toolsDir)
            slog.warn(s"Extracted IMCE ontology tools from ${zip.name}")
            slog.warn(s"Ontology tools in: $toolsDir")
          }
        }

        toolsDir
      },

      setupFuseki := {

        val slog = streams.value.log

        val fusekiDir = baseDirectory.value / "target" / "fuseki"

        if (fusekiDir.exists()) {
          slog.warn(s"Apache jena fuseki already extracted in $fusekiDir")
        }  else {
          IO.createDirectory(fusekiDir)

          val jfilter: DependencyFilter = new DependencyFilter {
            def apply(c: String, m: ModuleID, a: Artifact): Boolean =
              a.extension == "tar.gz" &&
                m.organization.startsWith("org.apache.jena") &&
                m.name.startsWith("apache-jena-fuseki")
          }
          update.value
            .matching(jfilter)
            .headOption
            .fold[Unit] {
            slog.error("Cannot find apache-jena-fuseki tar.gz!")
          } { tgz =>
            slog.warn(s"found: $tgz")
            val dir = target.value / "tarball"
            Process(Seq("tar", "--strip-components", "1", "-zxf", tgz.getAbsolutePath), Some(fusekiDir)).! match {
              case 0 => ()
              case n => sys.error("Error extracting " + tgz + ". Exit code: " + n)
            }
          }
        }

        fusekiDir
      },

      //makePom := { artifactZipFile; makePom.value },

      sourceGenerators in Compile := Seq(),

      managedSources in Compile := Seq(),

      // disable publishing the main jar produced by `package`
      publishArtifact in(Compile, packageBin) := false,

      // disable publishing the main API jar
      publishArtifact in(Compile, packageDoc) := false,

      // disable publishing the main sources jar
      publishArtifact in(Compile, packageSrc) := false,

      // disable publishing the jar produced by `test:package`
      publishArtifact in(Test, packageBin) := false,

      // disable publishing the test API jar
      publishArtifact in(Test, packageDoc) := false,

      // disable publishing the test sources jar
      publishArtifact in(Test, packageSrc) := false
    )
