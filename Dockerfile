# Use a lightweight Nginx web server
FROM nginx:alpine

# Copy your HTML portfolio files into Nginx's default public folder
COPY index.html /usr/share/nginx/html/

# Expose port 80 for web traffic
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
