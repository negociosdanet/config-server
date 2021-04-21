pipeline {
    agent { 
        docker { image 'maven:3.3.3' }
    }

    stages {

        stage('clone') {
            steps {
                git branch: 'development',
                    url: 'https://github.com/negociosdanet/config-server.git'
            }
        }

        stage('build') {
            steps {
                sh 'mvn -B package -DskipTests --file pom.xml'
            }
        }

        stage('unit test') {
            steps {
                sh 'mvn -B package --file pom.xml'
                junit '**/target/surefire-reports/TEST-*.xml'
                archiveArtifacts 'target/*.jar'
            }
        }
    }
}