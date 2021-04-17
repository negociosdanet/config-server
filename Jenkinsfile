pipeline {
    agent { label 'java8' }
    environment {
        EMAIL_RECIPIENTS = 'mariosergio952@hotmail.com.br'
    }

    stages {
        stage('Clone') {
            echo 'Pulling...' + env.BRANCH_NAME
            git 'https://github.com/negociosdanet/config-server.git'
        }

        stage('Build') {
            steps {
                script {
                    def mvnHome = tool 'Maven 3.5.2'
                    def targetVersion = getDevVersion()
                    print 'target build version...'
                    print targetVersion
                    sh "'${mvnHome}/bin/mvn' -Dmaven.test.skip=true -Dbuild.number=${targetVersion} clean package"
                    def pom = readMavenPom file: 'pom.xml'
                    developmentArtifactVersion = "${pom.version}-${targetVersion}"
                    print pom.version
                }

            }
        }

        stage('Unit tests') {
            steps {
                script {
                    def mvnHome = tool 'Maven 3.5.2'
                    sh "'${mvnHome}/bin/mvn' test"
                    junit '**//*target/surefire-reports/TEST-*.xml'
                    archive 'target*//*.jar'
                }
            }
        }

        stage('Sonar scan execution') {
            steps {
                script {
                    def mvnHome = tool 'Maven 3.5.2'
                    withSonarQubeEnv {
                        sh "'${mvnHome}/bin/mvn' verify sonar:sonar -Dintegration-tests.skip=true -Dmaven.test.failure.ignore=true"
                    }
                }
            }
        }

        stage('docker build') {
            echo 'docker build...'
            sh "docker build -t mariosergioas/config-server ." 
        }

        stage('docker push') {
            echo 'docker push...'
            sh "docker push mariosergioas/config-server" 
        }
        
    }
    post {
        always {
            deleteDir()
        }
        success {
            sendEmail("Successful");
        }
        unstable {
            sendEmail("Unstable");
        }
        failure {
            sendEmail("Failed");
        }
    }

// The options directive is for configuration that applies to the whole job.
    options {
        // For example, we'd like to make sure we only keep 10 builds at a time, so
        // we don't fill up our storage!
        buildDiscarder(logRotator(numToKeepStr: '5'))

        // And we'd really like to be sure that this build doesn't hang forever, so
        // let's time it out after an hour.
        timeout(time: 25, unit: 'MINUTES')
    }

}
def developmentArtifactVersion = ''
def releasedVersion = ''
// get change log to be send over the mail
@NonCPS
def getChangeString() {
    MAX_MSG_LEN = 100
    def changeString = ""

    echo "Gathering SCM changes"
    def changeLogSets = currentBuild.changeSets
    for (int i = 0; i < changeLogSets.size(); i++) {
        def entries = changeLogSets[i].items
        for (int j = 0; j < entries.length; j++) {
            def entry = entries[j]
            truncated_msg = entry.msg.take(MAX_MSG_LEN)
            changeString += " - ${truncated_msg} [${entry.author}]\n"
        }
    }

    if (!changeString) {
        changeString = " - No new changes"
    }
    return changeString
}

def sendEmail(status) {
    mail(
            to: "$EMAIL_RECIPIENTS",
            subject: "Build $BUILD_NUMBER - " + status + " (${currentBuild.fullDisplayName})",
            body: "Changes:\n " + getChangeString() + "\n\n Check console output at: $BUILD_URL/console" + "\n")
}

def getDevVersion() {
    def gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
    def versionNumber;
    if (gitCommit == null) {
        versionNumber = env.BUILD_NUMBER;
    } else {
        versionNumber = gitCommit.take(8);
    }
    print 'build  versions...'
    print versionNumber
    return versionNumber
}

def getReleaseVersion() {
    def pom = readMavenPom file: 'pom.xml'
    def gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
    def versionNumber;
    if (gitCommit == null) {
        versionNumber = env.BUILD_NUMBER;
    } else {
        versionNumber = gitCommit.take(8);
    }
    return pom.version.replace("-SNAPSHOT", ".${versionNumber}")
}