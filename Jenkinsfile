pipeline{
    agent any
    stages{
        stage('Git checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/etahamad/demo-counter-app'
            }
        }
        stage('UNIT Testing'){
            steps{
                sh 'mvn test'
            }
        }
        stage('Integration Testing'){
            steps{
                sh 'mvn verify -DskipUnitTests'
            }
        }
        stage('Maven Build'){
            steps{
                sh 'mvn clean install'
            }
        }
        stage('SonarQube Analysis'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-api', installationName: 'sonarserver'){
                        sh 'mvn clean package sonar:sonar'
                    }
                }
            }
        }
        stage('Quality Gate Check'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialId: 'sonar-api'
                }
            }
        }
        stage('Upload Artifact to nexus'){
            steps{
                script{
                    pom = readMavenPom file: 'pom.xml'
                    nexusRepo = pom.version.endsWith('-SNAPSHOT') ? 'DemoApplicationSNAPSHOT' : 'DemoApplicationRelease'
                    filesByGlob = findFiles(glob: "target/*.jar");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    nexusArtifactUploader artifacts:
                    [
                        [
                            artifactId: pom.artifactId,
                            classifier: '',
                            file: artifactPath,
                            type: 'jar',
                        ]
                    ],
                    credentialsId: 'nexus-auth',
                    groupId: pom.groupId,
                    nexusUrl: '165.227.147.128:8081',
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    repository: nexusRepo,
                    version: pom.version
                }
            }
        }
    }
}
