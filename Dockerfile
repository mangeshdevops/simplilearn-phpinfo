#Download alpine the Docker image (alpine operating system WITHOUT any kernel BECAUSE container used kernel of the HOST machine)
#i.e. binaries, libararies, etc.
FROM alpine
#To install PHP inside the container (similar to "apt install php")
RUN apk add php
#Create a folder name app insider the container
WORKDIR /app
#Copy the source code inside the container
COPY src/index.php /app
#Run the following command inside the container
ENTRYPOINT ["php"]
#Pass this arguments to the command
CMD ["-f", "index.php", "-S", "0.0.0.0:8080"]
# Note Here 
# 1: without brackets : sh -c "php -f index.php -S 0.0.0.0:8080"
# For this PID = 1 and process used as "sh" means shell
# 2: with brackets : php -f index.php -S 0.0.0.0:8080
# For this PID = 1 and process used as "php" directly.

#Expose port 8080 inside the container
EXPOSE 8080
