pipeline {
    agent any
    environment{
        DOCKER_TAG = getDockerTag()
    }
    stages{
       stage('code cloning'){
         steps{
            git 'https://github.com/shivaraj536211/node-app.git'
               }
           }
         stage('code build by maven'){
               steps{
               sh'mvn install'
           }
          } 
        
        stage('Build Docker Image'){
            steps{
                sh "docker build . -t shivaraj536211/vprofile2:${DOCKER_TAG}"
            }
        }
        stage('DockerHub Push'){
            steps{
                withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]){
                    sh "docker login -u shivaraj536211 -p ${dockerpasswD}"
                    sh "docker push shivaraj536211/vprofile2:${DOCKER_TAG}"
                }
            }
        }
        stage('Deploy to k8s'){
            steps{
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
               sshagent(['kops-machine2']) {
                    sh "scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml ubuntu@13.127.160.112:/home/ubuntu/"
                    script{
                        try{
                            sh "ssh ubuntu@52.66.160.84 kubectl apply -f ."
                        }catch(error){
                            sh "ubuntu@52.66.160.84 kubectl create -f ."
                        }
                    }
                }
            }
        }
  }  
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}

