FROM nginx:1.24-alpine

# Delete the default config
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy the custom config
COPY nginx.conf /etc/nginx/conf.d/app.conf

# Copying static files
COPY static/ /usr/share/nginx/html/

# Setting rights
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

EXPOSE 80

# A simple check for nginx availability
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]