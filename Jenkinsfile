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
                def pom = readMavenPom file: 'pom.xml'
                print pom.version
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
                def pom = readMavenPom file: 'pom.xml'
                sh 'docker build . -t mariosergioas/config-server:${{pom.version}}'
            }
        }

        stage('docker build') {
            steps {
                def pom = readMavenPom file: 'pom.xml'
                sh 'docker push -t mariosergioas/config-server:${{pom.version}}'
            }
        }
    }
}