pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mlops-midterm-fa23-bai-023"
        CONTAINER_NAME = "mlops-app-fa23-bai-023"
        GITHUB_RAW = "https://raw.githubusercontent.com/Khawaja-Muhammad-Haseeb/Lab_Midterm/main/dataset/train.csv"
    }

    stages {

        // ================================================
        // STAGE 1: CLONE REPOSITORY
        // ================================================
        stage('Clone Repository') {
            steps {
                echo 'Cloning GitHub repository...'
                git branch: 'main',
                    url: 'https://github.com/Khawaja-Muhammad-Haseeb/Lab_Midterm.git'
            }
        }

        // ================================================
        // STAGE 2: FETCH DATASET FROM GITHUB (Step 3)
        // ================================================
        stage('Fetch Dataset') {
            steps {
                echo 'Fetching dataset from GitHub...'
                sh '''
                    mkdir -p dataset
                    curl -L "$GITHUB_RAW" -o dataset/train.csv
                    echo "Dataset fetched successfully"
                    wc -l dataset/train.csv
                '''
            }
        }

        // ================================================
        // STAGE 3: TRAIN THE MODEL (Step 4)
        // ================================================
        // stage('Train Model') {
        //     steps {
        //         echo 'Installing dependencies and training model...'
        //         sh '''
        //             pip install scikit-learn pandas numpy joblib --break-system-packages --quiet
        //             python3 train.py
        //             echo "Training complete"
        //             cat metrics.json
        //         '''
        //     }
        // }

        // ================================================
        // STAGE 4: BUILD DOCKER IMAGE (Step 5)
        // ================================================
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh '''
                    docker build -t $DOCKER_IMAGE .
                    echo "Docker image built: $DOCKER_IMAGE"
                '''
            }
        }

        // ================================================
        // STAGE 5: RUN DOCKER CONTAINER (Step 6)
        // ================================================
        stage('Run Docker Container') {
            steps {
                echo 'Starting Docker container on port 8000...'
                sh '''
                    # Stop and remove existing container if running
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME   || true

                    # Run the new container
                    docker run -d \
                        --name $CONTAINER_NAME \
                        -p 8000:8000 \
                        $DOCKER_IMAGE

                    echo "Container started: $CONTAINER_NAME"
                '''
            }
        }

        // ================================================
        // STAGE 6: VERIFY API IS RUNNING
        // ================================================
        stage('Verify API') {
            steps {
                echo 'Waiting for API to be ready...'
                sh '''
                    sleep 5
                    curl -f http://localhost:8000/metrics
                    echo ""
                    echo "API is live and /metrics is accessible!"
                '''
            }
        }
    }

    // ================================================
    // POST ACTIONS
    // ================================================
    post {
        success {
            echo '=========================================='
            echo 'PIPELINE COMPLETED SUCCESSFULLY'
            echo 'API running at http://localhost:8000'
            echo 'Metrics at  http://localhost:8000/metrics'
            echo '=========================================='
        }
        failure {
            echo 'Pipeline failed. Cleaning up...'
            sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME   || true
            '''
        }
    }
}
