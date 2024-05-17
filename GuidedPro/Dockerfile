# Use the official nginx image from the Docker Hub
FROM nginx:alpine

# Remove the default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the contents of the GuidedPro directory into the nginx web root
COPY GuidedPro /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
