FROM python:3

# Set the working directory in the container
WORKDIR /app

# Copy the HTML file from the build context into the container
COPY Namecode.html /app

# Expose port 8000 to the outside world
EXPOSE 8000

# Command to run the Python HTTP server serving the HTML file
CMD ["python", "-m", "http.server", "8000"]
