# --- STAGE 1: Build the React application ---
# Use a lightweight Node image for building
FROM node:20-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json/yarn.lock to leverage Docker cache
# If these files haven't changed, this layer won't be rebuilt
COPY package.json ./
COPY package-lock.json ./
# If you use yarn, use: COPY yarn.lock ./

# Install dependencies (use 'npm ci' for clean install if possible)
RUN npm install
# If you use yarn, use: RUN yarn install --production=false

# Copy the rest of the application files
COPY . .

# Build the React application (replace 'build' with your actual build script name if different)
# The output will go to the 'build' folder by default for create-react-app
RUN npm run build
# If you use Vite/other builders, your output directory might be 'dist' - adjust accordingly

# --- STAGE 2: Serve the application with Nginx ---
# Use a super-lightweight Nginx image
FROM nginx:alpine AS production

# Copy the built files from the 'builder' stage into Nginx's HTML directory
# NOTE: Replace 'build' with 'dist' if your build output is 'dist'
COPY --from=builder /app/build /usr/share/nginx/html

# A custom Nginx config is often needed for client-side routing (like React Router)
# If you have an nginx.conf file in your project root, uncomment the line below:
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 (standard for web servers)
EXPOSE 80

# Command to run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
