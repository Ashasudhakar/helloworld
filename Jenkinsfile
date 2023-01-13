pipeline {

    agent {
        docker {
            image 'hashicorp/terraform:latest'
            args  '--entrypoint="" -u root'
        }
    }

    stages {
        stage('TF Input') {
            steps {
                def terraformInputsFilePath = input message: 'Upload your terraform inputs file', parameters: [file(description: 'terraform inputs', name: 'uploadedFile')]
            }
        }

        stage('TF Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "terraform-auth",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh "cat ${terraformInputsFilePath}"
                    sh 'terraform init'
                    sh 'terraform plan -out myplan'
                }
            }      
        }

        stage('Approval') {
            steps {
                script {
                    def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
                }
            }
        }

        stage('TF Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "terraform-auth",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh 'terraform apply -input=false myplan'
                }
            }
        }
    }
}