#!/usr/bin/env groovy

def FUSEKI_DATASET_NAME=''

pipeline {
    /* Agent directive is required. */
    agent { node { label 'imce-infr-dev-01.jpl.nasa.gov' } } 

    parameters {
        /* What to perform during build */
        string(name: 'BOOTSTRAP_BUILDS', defaultValue: 'TRUE', description: 'Whether or not to bootstrap subsequent builds and calculate dependencies. It makes no sense to skip this step.')
        string(name: 'VALIDATE_ROOTS', defaultValue: 'TRUE', description: 'Whether or not to validate ontologies.')
        string(name: 'LOAD_PRODUCTION', defaultValue: 'TRUE', description: 'Whether or not to load data. This calculate entailments and load data to fuseki.')
        string(name: 'RUN_REPORTS', defaultValue: 'FALSE', description: 'Whether or not to run reports.')

        string(name: 'OML_REPO', defaultValue: 'gov.nasa.jpl.imce.caesar.workflows.europa', description: 'Repository where OML data to be converted is stored.')
        string(name: 'OML_REPO_BRANCH', defaultValue: 'user-model/authored/efse/europa', description: 'Repository branch where OML data version to be converted is stored.')
        string(name: 'ONTOLOGY_REPO', defaultValue: 'gov.nasa.jpl.imce.ontologies.public', description: 'Repository where public ontology data is stored.')
        string(name: 'ONTOLOGY_REPO_BRANCH', defaultValue: 'feature/IMCEIS-1715-create-temporary-branch-of-ontologie', description: 'Repository branch where public ontology data version is stored.')

        string(name: 'FUSEKI_PORT_NUMBER', defaultValue: '3030', description: 'Port number of the Fuseki database.')
    }

    environment {
        GEM_HOME = '/home/jenkins/.rvm/gems/jruby-1.7.19'
        PATH = '$PATH:/home/jenkins/.rvm/gems/jruby-1.7.19/bin:/home/jenkins/.rvm/gems/jruby-1.7.19@global/bin:/home/jenkins/.rvm/rubies/jruby-1.7.19/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/jenkins/.rvm/bin'
        SBT_OPTIONS = '-batch -no-colors'
        VNC_OUT = './vnc.out'
    }

    stages {

        stage('Setup') {
            steps {
                echo "Setting up environment..."

                sh "env"
                sh "sbt $SBT_OPTIONS clean cleanFiles"
                sh "sbt $SBT_OPTIONS setupTools setupExportResults"

                // setup Fuseki, ontologies, tools, environment
            }
        }

        stage('Checkout OML') {
            when {
                expression { params.OML_REPO != 'undefined' }
            }
            steps {
                echo "Checkout OML..."

                withCredentials([usernamePassword(credentialsId: 'git-credentials-NFR-caesar.ci.token-ID', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    sh 'git config user.email "brian.p.satorius@jpl.nasa.gov"'
                    sh 'git config user.name "Brian Satorius (as CAESAR CI agent)"'
                    sh "scripts/import.sh ${OML_REPO} ${OML_REPO_BRANCH}"
                    script {
                        FUSEKI_DATASET_NAME = sh (
                            script: 'cd "target/import/${OML_REPO}"; git rev-parse HEAD',
                            returnStdout: true
                        ).trim()
                        echo "FUSEKI_DATASET_NAME: ${FUSEKI_DATASET_NAME}"
                    }
                }

                echo "Checkout vocabulary..."
                withCredentials([usernamePassword(credentialsId: 'git-credentials-NFR-caesar.ci.token-ID', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    sh 'git config user.email "brian.p.satorius@jpl.nasa.gov"'
                    sh 'git config user.name "Brian Satorius (as CAESAR CI agent)"'
                    sh "scripts/import-vocabulary.sh ${ONTOLOGY_REPO} ${ONTOLOGY_REPO_BRANCH}"
                }
            }
        }

        stage('OML to OWL') {            
            steps {
                echo "Converting OML to OWL..."

                //withCredentials([usernamePassword(credentialsId: 'git-credentials-NFR-caesar.ci.token-ID', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    //sh "scripts/oml-conversion.sh target/import/${OML_REPO}/resources"
                //}
                sh "scripts/oml-conversion.sh ${OML_REPO}/resources"
            }
        }

        stage('Bootstrap Builds') {
            when {
                expression { params.BOOTSTRAP_BUILDS == 'TRUE' }
            }
            steps {
                echo "Bootstrapping builds..."

                sh "cd workflow; source ./env.sh ${FUSEKI_DATASET_NAME} ${params.FUSEKI_PORT_NUMBER}; /usr/bin/make bootstrap"
                sh "cd workflow; source ./env.sh ${FUSEKI_DATASET_NAME} ${params.FUSEKI_PORT_NUMBER}; /usr/bin/make location-mapping"
            }
        }

        stage('Validate Roots') {
            when {
                expression { params.VALIDATE_ROOTS == 'TRUE' }
            }
            steps {
                echo "Validating ontologies roots..."

                sh "cd workflow; source ./env.sh ${FUSEKI_DATASET_NAME} ${params.FUSEKI_PORT_NUMBER}; /usr/bin/make validate-roots"
            }
}

        stage('Load-Production') {
            when {
                expression { params.LOAD_PRODUCTION == 'TRUE' }
            }
            steps {
                // dataset name is the oml repo commit id
                echo "Creating Dataset on Fuseki name  ${FUSEKI_DATASET_NAME} port number ${params.FUSEKI_PORT_NUMBER}"
                sh "cd workflow; source ./env.sh ${FUSEKI_DATASET_NAME} ${params.FUSEKI_PORT_NUMBER}; ../scripts/create-dataset.sh"

                echo "Loading production..."
                sh "cd workflow; source ./env.sh ${FUSEKI_DATASET_NAME} ${params.FUSEKI_PORT_NUMBER}; /usr/bin/make load-production"
            }
        }

        stage("Run-Reports") {
            when {
                expression { params.RUN_REPORTS == 'TRUE' }
            }
            steps {
                echo "Run reports (TBD)..."
                //sh "cd workflow; source ./env.sh ${params.FUSEKI_DATASET_NAME} ${params.FUSEKI_PORT_NUMBER}; /usr/bin/make run-reports"
            }
        }
    }

    post {
        always {
            junit 'target/**/*.xml'
        }
    }

}
