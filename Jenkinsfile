pipeline {

    agent {
        docker {
            image 'hashicorp/terraform:latest'
            args  '--entrypoint="" -u root'
        }
    }
    
    options {
        ansiColor('xterm')
    }

    parameters {
        stashedFile 'Terraform_Input_File'
    }

    stages {
        stage('TF Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "terraform-auth",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    unstash 'Terraform_Input_File'
                    sh 'cat Terraform_Input_File > terraform.tfvars'
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
                    unstash 'Terraform_Input_File'
                    sh 'cat Terraform_Input_File > terraform.tfvars'
                    sh 'terraform apply -input=false myplan'
                }
            }
        }
    }
}