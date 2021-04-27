def pom = ""
def pomVersion = ""
def projectName = ""
def aliasNameDocker = "mariosergioas"

pipeline {
    agent { 
        docker { image 'maven:3.3.3' }
    }

    stages {

        stage('Build') {
            steps {
                script { 
                    pom = readMavenPom file: 'pom.xml'
                    pomVersion = pom.version
                    projectName = pom.name
                    print pomVersion
                    sh 'mvn -B package -DskipTests --file pom.xml'
                }
            }
        }

        stage('Unit tests') {
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
                sh "docker build . -t ${aliasNameDocker}/${projectName}:${pomVersion}"
            }
        }

        stage('docker push') {
            steps {
                sh "docker push ${aliasNameDocker}/${projectName}:${pomVersion}"
            }
        }

        stage('Development deploy') {
            steps {
                script {
                    print 'deploy'
                }
            }
        }

        stage('Homologation deploy') {
            steps {
                script {
                    timeout(time: 3, unit: 'MINUTES') {
                        input message: 'Approve deployment to homologation?'
                    }
                }
            }
        }

        stage('Production deploy') {
            steps {
                script {
                    timeout(time: 3, unit: 'MINUTES') {
                        input message: 'Approve deployment to production?'
                    }
                }
            }
        }
    }
}