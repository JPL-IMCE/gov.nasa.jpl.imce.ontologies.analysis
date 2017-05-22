#!/usr/bin/env groovy

pipeline {
    agent any

    parameters {
        string(name: 'JRUBY', defaultValue: '/usr/local/Cellar/jruby/jruby-1.7.24/bin/jruby', description: '')
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

                sh "cd workflow; . env.sh; /usr/bin/make \$WORKFLOW/Makefile"
                sh "cd workflow; . env.sh; /usr/bin/make location-mapping"
                sh "cd workflow; . env.sh; /usr/bin/make validate-roots"

                junit '**/target/*.xml'
            }
        }
    }
}
