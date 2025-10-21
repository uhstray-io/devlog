# Use the official Hugo image
FROM hugomods/hugo:exts

# Set the working directory
WORKDIR /src

# Copy the Hugo site files
COPY . /src

# Expose port 1313 for Hugo's development server
EXPOSE 1313

# Default command to serve the site
CMD ["hugo", "server", "--bind", "0.0.0.0", "--port", "1313", "--baseURL", "http://localhost:1313"]