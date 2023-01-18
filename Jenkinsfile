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
        string(
            defaultValue: 's3,ec2',
            name: 'LIST_MODULES',
            trim: true
        )
        string(
            defaultValue: 'dev-1,qa-1',
            name: 'ENVIRONMENTS',
            trim: true
        )
        string(
            defaultValue: 'main',
            name: 'MODULES_GIT_BRANCH',
            trim: true
        )
    }

    stages {
        stage('Getting Started with modules deployment') {
            steps {
                script {
                    modules = params.LIST_MODULES.split(",")
                    envs    = params.ENVIRONMENTS.split(",")

                    modules.each { module ->
                        stage("Updating module source in terraform main file") {
                            sh "sed -i 's/var_module_name/${module}/' main.tf"
                            sh "sed -i 's/var_git_branch/${params.MODULES_GIT_BRANCH}/' main.tf"
                        }

                        envs.each { env ->
                            print "###### Start executing terraform deployment for the module ${module} for env ${env} ######"

                            stage("${module}-${env}-stage-TF-PLAN") {
                                withCredentials([[
                                    $class: 'AmazonWebServicesCredentialsBinding',
                                    credentialsId: "terraform-auth",
                                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                ]]) {
                                    if (env.startsWith('dev')) {
                                        folder_prefix = 'dev'
                                    } else if (env.startsWith('qa')) {
                                        folder_prefix = 'qa'
                                    } else if (env.startsWith('prod')) {
                                        folder_prefix = 'prod'
                                    }

                                    sh """
                                    terraform init -backend-config "key=${folder_prefix}/${env}.tfstate --reconfigure"
                                    terraform plan --var-file .terraform/modules/common/${module}/${folder_prefix}/${env}.tfvars -out ${env}_tfplan
                                    """
                                }
                            }

                            stage("${module}-${env}-stage-TF-APPLY") {
                                withCredentials([[
                                    $class: 'AmazonWebServicesCredentialsBinding',
                                    credentialsId: "terraform-auth",
                                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                ]]) {
                                    sh "terraform apply -input=false ${env}_tfplan"
                                    // sh "terraform destroy --auto-approve --var-file .terraform/modules/common/${module}/${folder_prefix}/${env}.tfvars"
                                }
                            }
                            print "###### End executing terraform deployment for the module ${module} for env ${env} ######"
                        }
                    }
                }
            }
        }
    }
}