FROM python:3.10-slim

WORKDIR /app

# Copy all files
COPY . .

# Install API dependencies only
RUN pip install --no-cache-dir \
    fastapi \
    uvicorn \
    scikit-learn \
    joblib \
    numpy
RUN python3 train.py   
# Expose port 8000
EXPOSE 8000

# Start FastAPI app
# model.pkl and metrics.json are copied by Jenkins before build
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
