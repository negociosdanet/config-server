def pomVersion = ""

pipeline {
    agent { 
        docker { image 'maven:3.3.3' }
    }

    stages {

        /*stage('clone') {
            steps {
                git branch: 'development',
                    url: 'https://github.com/negociosdanet/config-server.git'
            }
        }*/

        stage('build') {
            steps {
                sh 'mvn -B package -DskipTests --file pom.xml'
                pomVersion = readMavenPom file: 'pom.xml'
                print pomVersion
            }
        }

        stage('unit test') {
            steps {
                sh 'mvn -B test --file pom.xml'
                junit '**//*target/surefire-reports/TEST-*.xml'
                archive 'target*//*.jar'
            }
        }

        stage('docker build') {
            steps {
                sh 'docker build . -t mariosergioas/config-server:${{pomVersion}}'
            }
        }

        stage('docker push') {
            steps {
                sh 'docker push -t mariosergioas/config-server:${{pomVersion}}'
            }
        }
    }
}