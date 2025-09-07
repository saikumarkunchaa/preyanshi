pipeline {
    agent any

    options {
        // Add this block to define triggers
        triggers {
            githubPush()
        }
    }

    stages {
        stage('Initialize') {
            steps {
                echo 'Displaying Node and npm versions for debugging...'
                sh 'node -v'
                sh 'npm -v'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing dependencies with `npm ci`...'
                sh 'npm ci'
            }
        }

        stage('Lint and Test') {
            steps {
                echo 'Running linting and tests...'
                sh 'npm test -- --watchAll=false'
            }
        }

        stage('Build') {
            steps {
                echo 'Creating production build with `npm run build`...'
                sh 'npm run build'
            }
        }
    }
}
