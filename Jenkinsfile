def pomVersion = ""

pipeline {
    agent { 
        docker { image 'maven:3.3.3' }
    }

    stages {

        stage('build') {
            steps {
                script { 
                    pomVersion = readMavenPom file: 'pom.xml'
                    pomVersion = pomVersion.version
                    print pomVersion
                    sh 'mvn -B package -DskipTests --file pom.xml'
                }
            }
        }

        stage('unit test') {
            steps {
                script { 
                    sh 'mvn -B test --file pom.xml'
                    junit '**//*target/surefire-reports/TEST-*.xml'
                    archiveArtifacts 'target*//*.jar'
                }
            }
        }

        stage('docker build') {
            steps {
                sh "docker build . -t mariosergioas/config-server:${pomVersion}"
            }
        }

        stage('docker push') {
            steps {
                sh "docker push mariosergioas/config-server:${pomVersion}"
            }
        }

        stage('deploy to dev') {
            steps {
                print 'deploy'
            }
        }

        stage('deploy to UAT') {
            steps {
                script {
                    timeout(time: 3, unit: 'MINUTES') {
                        input message: 'Approve deployment to UAT?'
                    }
                }
            }
        }
    }
}