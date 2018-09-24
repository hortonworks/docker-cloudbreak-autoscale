pipeline {
    agent any

    stages {
        stage('Tag Cloudbreak-autoscale') {
            environment {
                DOCKERHUB_USERNAME = credentials('dockerhub-username')
                DOCKERHUB_PASSWORD = credentials('dockerhub-password')
            }
            steps {
                script {
                    currentBuild.displayName = "${BUILD_NUMBER}-${VERSION}"
                }
                sh '''
                    make dockerhub
                '''
            }
        }
    }
}