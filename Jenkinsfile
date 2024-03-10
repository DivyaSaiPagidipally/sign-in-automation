pipeline{
    agent {
        docker { image 'node:20.9.0-alpine3.18' 
            args '-p 4000:4000'}
    }
        stages {
            stage('install depedencies'){
                steps{
                    sh 'npm install'
                }
            }
           stage('run build'){
            steps{
                sh 'npm run build'
            }
           }
            stage('run tests'){
                steps{
                    sh 'npm run test'
                }
            }   
            stage('notification'){
                steps{
                mail bcc: '', body: 'Build result', cc: 'Email for build', from: '', replyTo: '', subject: 'Sending notification for each build', to: 'divyasai375@gmail.com'
            }
        }
    }
}
    
