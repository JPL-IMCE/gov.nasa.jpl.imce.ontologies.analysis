#!/usr/bin/env groovy

pipeline {
    /* Agent directive is required. */
    agent { node { label 'imce-infr-dev-01.jpl.nasa.gov' } } 

    parameters {
        /* What to perform during build */
        string(name: 'BOOTSTRAP_BUILDS', defaultValue: 'TRUE', description: 'Whether or not to bootstrap subsequent builds and calculate dependencies. It makes no sense to skip this step.')
        string(name: 'VALIDATE_ROOTS', defaultValue: 'TRUE', description: 'Whether or not to validate ontologies.')
        string(name: 'LOAD_PRODUCTION', defaultValue: 'TRUE', description: 'Whether or not to load data. This calculate entailments and load data to fuseki.')
        
        string(name: 'OML_REPO', defaultValue: 'undefined', description: 'Repository where OML data to be converted is stored.')
        string(name: 'FUSEKI_DATASET_NAME', defaultValue: 'imce-ontologies', description: 'Name of the Fuseki dataset to be used.')
        string(name: 'FUSEKI_PORT_NUMBER', defaultValue: '3030', description: 'Port number of the Fuseki database.')
    }

    environment {
        GEM_HOME = '/home/jenkins/.rvm/gems/jruby-1.7.19'
        PATH = '$PATH:/home/jenkins/.rvm/gems/jruby-1.7.19/bin:/home/jenkins/.rvm/gems/jruby-1.7.19@global/bin:/home/jenkins/.rvm/rubies/jruby-1.7.19/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/jenkins/.rvm/bin'
        SBT_OPTIONS = '-batch -no-colors'
        VNC_OUT = './vnc.out'
        CONVERT = '/path/to/OMLConverter'
        PUBLIC = '/path/to/gov.nasa.jpl.imce.ontologies.public'
    }

    stages {

        stage('Setup') {
            steps {
                echo "Setting up environment..."

                sh "env"
                sh "sbt $SBT_OPTIONS clean cleanFiles"
                sh "sbt $SBT_OPTIONS setupTools"

                // setup Fuseki, ontologies, tools, environment
            }
        }

        stage('Checkout OML') {
            when {
                expression { params.OML_REPO != 'undefined' }
            }
            steps {
                echo "Checkout OML..."

                sh "rm -rf target/ontologies"   // Need to make sure it's empty before cloning
                sh "mkdir -p target/ontologies; cd target/ontologies; git clone ${OML_REPO} ."
            }
        }

        stage('OML to OWL') {            
            steps {
                echo "Converting OML to OWL..."

                sh "cd target/workflow/artifacts"
                sh "bash -x ../../../scripts/setup target/ontologies/${OML_REPO}"
                sh "bash -x ../../../scripts/create-dataset ${params.JENA_DATASET_NAME} ${params.JENA_PORT_NUMBER}"
            }
        }

        stage('Bootstrap Builds') {
            when {
                expression { params.BOOTSTRAP_BUILDS == 'TRUE' }
            }
            steps {
                echo "Bootstrapping builds..."

                sh "cd workflow; source ./env.sh ${params.FUSEKI_DATASET_NAME} ${params.FUSEKI_PORT_NUMBER}; /usr/bin/make bootstrap"
                sh "cd workflow; source ./env.sh ${params.FUSEKI_DATASET_NAME} ${params.FUSEKI_PORT_NUMBER}; /usr/bin/make location-mapping"
            }
        }

        stage('Validate Roots') {
            when {
                expression { params.VALIDATE_ROOTS == 'TRUE' }
            }
            steps {
                echo "Validating ontologies roots..."

                sh "cd workflow; source ./env.sh ${params.FUSEKI_DATASET_NAME} ${params.FUSEKI_PORT_NUMBER}; /usr/bin/make validate-roots"
            }
}

        stage('Load-Production') {
            steps {
                echo "Loading production..."
                sh "cd workflow; source ./env.sh ${params.FUSEKI_DATASET_NAME} ${params.FUSEKI_PORT_NUMBER}; /usr/bin/make load-production"
            }
        }

        stage("Run-Reports") {
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
