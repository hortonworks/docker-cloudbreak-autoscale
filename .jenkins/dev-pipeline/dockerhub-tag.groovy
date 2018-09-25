pipeline {
    agent any

    parameters {
        string(name: 'VERSION', defaultValue: '', description: 'Cloudbreak version to build the Docker containers from. Example: 1.5.0-dev.87.')
    }

    environment {
        DOCKERHUB_USERNAME = credentials('dockerhub-username')
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
    }

    stages {
        stage('Tag Cloudbreak-autoscale') {
            steps {
                script {
                    currentBuild.displayName = "${BUILD_NUMBER}-${params.VERSION}"
                }
                sh '''
                    make dockerhub
                '''
            }
        }
    }
}