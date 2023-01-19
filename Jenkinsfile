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
            defaultValue: 's3',
            name: 'LIST_MODULES',
            trim: true
        )
        string(
            defaultValue: 'qa-1',
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
                    
                    def vars_file_list = []

                    envs.each { env ->
                        print "###### Start executing terraform deployment for env ${env} with modules ${modules} ######"

                        if (env.startsWith('dev')) {
                            folder_prefix = 'dev'
                        } else if (env.startsWith('qa')) {
                            folder_prefix = 'qa'
                        } else if (env.startsWith('prod')) {
                            folder_prefix = 'prod'
                        }

                        stage("Enabling selected modules for deployment in ${env} environment") {
                            modules.each { module ->
                                vars_file_list.add("-var-file .terraform/modules/${module}/${module}/${folder_prefix}/${env}.tfvars")
                                sh "sed -i \"s/enable_${module}_param/true/\" terraform.tfvars"
                            }
                        }

                        def vars_file_list_proposed = "${vars_file_list}".replace("[", "").replace("]", "").replace(",", "")

                        print "${vars_file_list_proposed}"

                        stage("${env}-stage-TF-PLAN") {
                            withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: "terraform-auth",
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                            ]]) {
                                sh """
                                terraform init -reconfigure -backend-config "key=${folder_prefix}/${env}.tfstate"
                                terraform plan ${vars_file_list_proposed} -out ${env}_tfplan
                                """
                            }
                        }

                        stage("${env}-stage-TF-APPLY") {
                            withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: "terraform-auth",
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                            ]]) {
                                sh "terraform apply -input=false ${env}_tfplan"
                                // sh "terraform destroy --auto-approve ${vars_file_list_proposed}"
                            }
                        }
                        print "###### End executing terraform deployment for env ${env} with modules ${modules} ######"

                        // resetting the list for next env execution in the loop
                        vars_file_list = []
                    }
                }
            }
        }
    }
}