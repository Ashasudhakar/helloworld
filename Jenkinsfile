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
                                    }
                                    if (env.startsWith('qa')) {
                                        folder_prefix = 'qa'
                                    }
                                    if (env.startsWith('prod')) {
                                        folder_prefix = 'prod'
                                    }
                                    sh """
                                    terraform init -backend-config "key=${folder_prefix}/${env}.tfstate" -migrate-state -force-copy
                                    terraform plan --var-file .terraform/modules/${module}/${module}/${folder_prefix}/${env}.tfvars -out ${env}_tfplan
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