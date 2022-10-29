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
        stage('Static Code Analysis (sonarqube)'){
            steps{
                withSonarQubeEnv(credentialsId: 'sonar-api') {
                    sh 'mvn clean packages sonar:sonar'
                }
            }
        }
    }
}
