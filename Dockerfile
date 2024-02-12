# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Create a simple Python script
RUN echo "print('Hello, Docker!')" > app.py

# Run app.py when the container launches
CMD ["python", "app.py"]
