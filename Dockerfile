# Base image — Node.js 18 on Alpine (tiny Linux)
FROM node:18-alpine

# Set working directory inside container
WORKDIR /app

# Copy dependency files first (Docker layer caching)
COPY package.json .

# Install dependencies
RUN npm install

# Copy rest of application code
COPY . .

# Expose port 3000
EXPOSE 3000

# Command to run the app
CMD ["node", "app.js"]
