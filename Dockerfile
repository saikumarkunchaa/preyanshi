# --- STAGE 1: Build the React application ---
# Use a lightweight Node image for building
FROM node:20-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json/yarn.lock to leverage Docker cache
COPY package.json ./
COPY package-lock.json ./

# Install ALL dependencies (including devDependencies like react-scripts)
# The npm install command without any flags installs both dependencies and devDependencies.
# Using 'npm ci' is recommended for Docker builds as it's faster and uses the lock file strictly.
RUN npm install
# OR (Recommended):
# RUN npm ci

# Copy the rest of the application files
COPY . .

# Build the React application
RUN npm run build

# --- STAGE 2: Serve the application with Nginx ---
# Use a super-lightweight Nginx image
FROM nginx:alpine AS production

# Copy the built files from the 'builder' stage into Nginx's HTML directory
COPY --from=builder /app/build /usr/share/nginx/html

# A custom Nginx config is often needed for client-side routing (like React Router)
# If you have an nginx.conf file in your project root, uncomment the line below:
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 (standard for web servers)
EXPOSE 8080

# Command to run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
