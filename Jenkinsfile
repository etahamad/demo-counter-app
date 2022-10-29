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
                    nexusArtifactUploader artifacts:
                    [
                        [
                            artifactId: 'springboot',
                            classifier: '',
                            file: 'target/Uberjar',
                            type: 'jar'
                        ]
                    ],
                    credentialsId: 'nexus-auth',
                    groupId: 'com.example',
                    nexusUrl: '165.227.147.128:8081',
                    nexusVersion: 'nexus2',
                    protocol: 'http',
                    repository: 'DemoApplicationRelease',
                    version: '1.0.0'
                }
            }
        }
    }
}
