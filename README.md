# Ontology Analysis

The ontology analysis workflow is intended for validating ontologies based on the core IMCE ontologies. It uses OWL ontologies (*TODO: OML AS INPUT*) as input, and produces test reports in the quasi-standard JUnit format. The following will walk through the environment setup, and give instructions on how to run the workflow (a) locally and (b) on a CI system such as Jenkins.

## Environment Setup

Running the workflow requires a number of tools to be configured: JRuby, SBT, Java 8 (JDK), Make. When using a CI server (such as Jenkins), a number of plugins are recommended to be installed. This is mentioned at the bottom of this section.

### JRuby
Ensure that JRuby 1.7.24 is installed. **Note:** it is important to install version 1.7.24, since there have been incompatible changes to the syntax and supported libraries in later versions.

JRuby 1.7.24 can be fetched from [http://jruby.org/files/downloads/1.7.24/index.html]. Ensure that an environment variable `JRUBY` exists, or that the command `which jruby` directs to the correct installation. 

### Java 8 JDK
Install the latest version of the Java 8 JDK from Oracle's website ([http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html]). It is recommended not to use OpenJDK. 

Java 8 JDK may already be pre-installed on your system. To check if this is the case, run `java -version` in a terminal window.

### SBT 0.13.x
Install the latest version of SBT 0.13.x from [http://www.scala-sbt.org/]. **Note:** do NOT use SBT 1.x (currently a pre-release) - there are known differences in syntax that will break part of the workflow.

### Make
Ensure that "make" is installed on the system. This is typically already the case for most Unix-based systems. Make is part of the GNU Utils (see [https://www.gnu.org/software/make/]). On MacOSX, this may require installing Xcode.

### Note For Running Under Continuous Integration
When running in a CI system (such as Jenkins), the agent may need to be configured appropriately. For Jenkins:

* Add an environment variable JRUBY under "Manage Jenkins" > "Manage Nodes" > (node name) > "Configure". The value should be *the absolute path to the jruby executable*: e.g., /usr/local/jruby/jruby-1.7.24/bin/jruby . **Note:** this is particularly important when using Jenkins 2.4.x, since Jenkins may NOT be aware of the system's environment settings.
* Install the SBT plugin (simply called "sbt plugin"), and configure an installation of SBT 0.13.x .

The above assumes a recommended standard installation of Jenkins 2.4.x, with the recommended plugins installed (e.g., GitHub plugin, JUnit plugin)

## Running
*MISSING: SETTING UP EXPORT RESULTS / RUNNING OML2OWL*

To run, execute the following commands in a terminal, starting at the project root:

```sh
sbt setupTools setupFuseki
cd workflow
. env.sh
make $WORKFLOW/Makefile
make location-mapping
make validate-roots
cd ..
```

**Note carefully:** The above assumes that an existing Fuseki instance with the content produced by loadprod (see [https://github.com/JPL-IMCE/gov.nasa.jpl.imce.ontologies.workflow]) already exists. This is done to avoid having to reason over basic ontologies again. Run the workflow from [https://github.com/JPL-IMCE/gov.nasa.jpl.imce.ontologies.workflow] before this (profile generation step is not necessary)!

### Running Under CI
For Jenkins, a pipeline script can be found in the root directory. This file is called `Jenkinsfile`.

### Examining Results
Note that results are stored in JUnit format in files under `target/*.xml`. With the JUnit plugin installed, Jenkins can read the analysis results. Note that also Eclipse's JUnit framework (and other JUnit-supporting (test) frameworks) will be able to parse and display the results of the analysis workflow.
