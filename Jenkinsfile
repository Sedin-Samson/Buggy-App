pipeline {
    agent any

    environment {
        IMAGE_TAG = "samson/buggyapp:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Cloning source code from GitHub"
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Sedin-Samson/Buggy-App.git',
                        credentialsId: 'acf2c1bd-dad9-44bf-8012-a65d773edc07'
                    ]]
                ])
            }
        }

        stage('Set ECR Image') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_REGION', variable: 'AWS_REGION'),
                    string(credentialsId: 'ECR_ACCOUNT_ID', variable: 'ECR_ACCOUNT_ID')
                ]) {
                    script {
                        env.ECR_IMAGE = "${ECR_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${env.IMAGE_TAG}"
                        echo "ECR Image set"
                    }
                }
            }
        }

        stage('Build App Image') {
            steps {
                script {
                    echo "Building Docker image for app"
                    sh "docker build -f Dockerfile.app -t ${env.ECR_IMAGE} ."
                }
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'AWS_SESSION_TOKEN', variable: 'AWS_SESSION_TOKEN'),
                    string(credentialsId: 'AWS_REGION', variable: 'AWS_REGION'),
                    string(credentialsId: 'ECR_ACCOUNT_ID', variable: 'ECR_ACCOUNT_ID')
                ]) {
                    script {
                        echo "Logging in to ECR"
                        sh(script: '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
                            aws ecr get-login-password --region $AWS_REGION | \
                            docker login --username AWS --password-stdin $ECR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                        ''', label: 'ECR Login')
                    }
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                echo "Pushing Docker image to ECR"
                sh "docker push ${env.ECR_IMAGE}"
            }
        }

        stage('Generate .env Files') {
            steps {
                withCredentials([
                    string(credentialsId: 'DB_PASSWORD', variable: 'DB_PASSWORD'),
                    string(credentialsId: 'DB_USER', variable: 'DB_USER'),
                    string(credentialsId: 'DB_NAME', variable: 'DB_NAME'),
                    string(credentialsId: 'DB_HOST', variable: 'DB_HOST'),
                    string(credentialsId: 'RAILS_ENV', variable: 'RAILS_ENV'),
                    string(credentialsId: 'SECRET_KEY_BASE', variable: 'SECRET_KEY_BASE')
                ]) {
                    script {
                        echo "Generating .env files"
                        
                        writeFile file: '.env', text: "ECR_IMAGE=${env.ECR_IMAGE}\n"

                        writeFile file: '.env.db.production', text: """
                            MYSQL_ROOT_PASSWORD=$DB_PASSWORD
                            MYSQL_DATABASE=$DB_NAME
                            MYSQL_USER=$DB_USER
                            MYSQL_PASSWORD=$DB_PASSWORD
                        """.stripIndent()

                        writeFile file: '.env.web.production', text: """
                            RAILS_ENV=$RAILS_ENV
                            DB_HOST=$DB_HOST
                            DB_NAME=$DB_NAME
                            DB_USER=$DB_USER
                            DB_PASSWORD=$DB_PASSWORD
                            SECRET_KEY_BASE=$SECRET_KEY_BASE
                        """.stripIndent()
                    }
                }
            }
        }

        stage('Restart Docker Compose Services') {
            steps {
                echo "Restarting Docker Compose services"
                sh '''
                    docker compose down
                    docker compose up -d --build
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
            // Optional: clean up Docker images
            // sh "docker rmi ${env.ECR_IMAGE}" 
        }
    }
}
