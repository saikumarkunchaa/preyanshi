// This 'pipeline' block tells Jenkins to use the Pipeline engine.
pipeline {
    // Defines where the pipeline will run.
    agent any

    // This 'triggers' block is now a direct child of the 'pipeline' block.
    triggers {
        githubPush()
    }

    // This 'stages' block is the key. Everything inside it becomes a stage.
    stages {
        stage('Initialize') { // This becomes the first box in the view.
            steps {
                echo 'Displaying Node and npm versions for debugging...'
                sh 'node -v'
                sh 'npm -v'
            }
        }

        stage('Install Dependencies') { // This becomes the second box.
            steps {
                echo 'Installing dependencies with `npm ci`...'
                sh 'npm ci'
            }
        }

        stage('Lint and Test') { // And so on for each stage.
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
