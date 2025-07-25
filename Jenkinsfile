pipeline {
    agent any

    environment {
        AWS_REGION             = credentials('AWS_REGION')
        ECR_REPO               = credentials('ECR_REPO')
        SECRET_KEY_BASE        = credentials('SECRET_KEY_BASE')
        DB_PASSWORD            = credentials('DB_PASSWORD')
        DB_USER                = credentials('DB_USER')
        DB_NAME                = credentials('DB_NAME')
        DB_HOST                = credentials('DB_HOST')
        ECR_ACCOUNT_ID         = credentials('ECR_ACCOUNT_ID')
        AWS_ACCESS_KEY_ID      = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY  = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_SESSION_TOKEN      = credentials('AWS_SESSION_TOKEN')
        RAILS_ENV              = credentials('RAILS_ENV')
        IMAGE_TAG              = "samson/buggyapp:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Cloning source code from GitHub with credentials"
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
                script {
                    env.ECR_IMAGE = "${env.ECR_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.IMAGE_TAG}"
                    echo "ECR Image set to: ${env.ECR_IMAGE}"
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
                script {
                    echo "Logging in to ECR using AWS credentials"
                    sh """
                        export AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}
                        export AWS_SESSION_TOKEN=${env.AWS_SESSION_TOKEN}
                        aws ecr get-login-password --region ${env.AWS_REGION} | \
                        docker login --username AWS --password-stdin ${env.ECR_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com
                    """
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                script {
                    echo "Pushing Docker image to ECR"
                    sh "docker push ${env.ECR_IMAGE}"
                }
            }
        }

        stage('Generate .env Files') {
            steps {
                script {
                    echo "Generating .env files"
                    
                    writeFile file: '.env', text: "ECR_IMAGE=${env.ECR_IMAGE}\n"

                    writeFile file: '.env.db.production', text: """
                        MYSQL_ROOT_PASSWORD=${env.DB_PASSWORD}
                        MYSQL_DATABASE=${env.DB_NAME}
                        MYSQL_USER=${env.DB_USER}
                        MYSQL_PASSWORD=${env.DB_PASSWORD}
                    """.stripIndent()

                    writeFile file: '.env.web.production', text: """
                        RAILS_ENV=${env.RAILS_ENV}
                        DB_HOST=${env.DB_HOST}
                        DB_NAME=${env.DB_NAME}
                        DB_USER=${env.DB_USER}
                        DB_PASSWORD=${env.DB_PASSWORD}
                        SECRET_KEY_BASE=${env.SECRET_KEY_BASE}
                    """.stripIndent()
                }
            }
        }

        stage('Restart Docker Compose Services') {
            steps {
                script {
                    echo "Restarting Docker Compose services"
                    sh """
                        docker compose down
                        docker compose up -d --build
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed. Optional cleanup below.'
            // sh "docker rmi ${env.ECR_IMAGE}" // Optional image cleanup
        }
    }
}
