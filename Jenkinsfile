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
        stage('Docker Build'){
            steps{
                script{
                    sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID etahamad/$JOB_NAME:v1.$BUILD_ID'
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID etahamad/$JOB_NAME:latest'
                }
            }
        }
        stage('Docker Push'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-auth', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]){
                        sh 'docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD'
                        sh 'docker image push etahamad/$JOB_NAME:v1.$BUILD_ID'
                        sh 'docker image push etahamad/$JOB_NAME:latest'
                    }
                }
            }
        }
    }
}
