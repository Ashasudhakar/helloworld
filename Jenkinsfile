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
                                    sh 'terraform init'
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
                                    export TF_VAR_state_file="${folder_prefix}/${env}.tfstate"
                                    export TF_VAR_var_file_path=".terraform/modules/${module}/${module}/${folder_prefix}/${env}.tfvars"
                                    export TF_VAR_plan_file_name="${env}_tfplan"
                                    
                                    terraform init -backend-config "key=$TF_VAR_state_file" -migrate-state
                                    terraform plan --var-file $TF_VAR_var_file_path -out $TF_VAR_plan_file_name"
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
                                    sh "terraform apply -input=false $TF_VAR_plan_file_name"
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