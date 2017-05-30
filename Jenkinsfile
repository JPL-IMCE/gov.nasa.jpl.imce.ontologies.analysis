#!/usr/bin/env groovy

pipeline {
    agent any

    parameters {
        string(name: 'ONT_METADATA', defaultValue: 'exporter-results/exportedOMFMetadata.owl', description: 'Ontology metadata file location. Should probably be moved into the build.sbt script and derived from input.')
    }

    environment {
        METADATA = "${env.WORKSPACE}${params.ONT_METADATA}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out project from SCM..."

                checkout scm
            }
        }

        stage('Setup') {
            steps {
                echo "Setting up environment..."

                sh "${tool name: 'default-sbt', type: 'org.jvnet.hudson.plugins.SbtPluginBuilder$SbtInstallation'}/bin/sbt setupTools setupFuseki"
                sh ". workflow/env.sh"
            }
        }

        stage('Build') {
            steps {
                sh "${tool name: 'default-sbt', type: 'org.jvnet.hudson.plugins.SbtPluginBuilder$SbtInstallation'}/bin/sbt compile test:compile"
                archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            }
        }

        stage('Validate-Ontologies') {
            steps {
                echo "Validating ontologies..."

                sh "echo WORKSPACE (via env): ${env.WORKSPACE}"
                sh "echo WORKSPACE (plain): ${WORKSPACE}"
                sh "echo WORKSPACE (pwd): ${pwd()}"
                sh "echo METADATA: \$METADATA"

                sh "cd workflow; . env.sh; /usr/bin/make \$WORKFLOW/Makefile"
                sh "cd workflow; . env.sh; /usr/bin/make location-mapping"
                sh "cd workflow; . env.sh; /usr/bin/make validate-roots"

                junit '**/target/*.xml'
            }
        }
    }
}
