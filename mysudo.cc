#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>


int main(int argc, char** argv) {
    int euid = geteuid();
    if(euid !=0){
        fprintf(stderr, "Not root! Does mysudo have the setuid bit set?\n");
        exit(EXIT_FAILURE);
    }

    setreuid(0, -1);
    auto mysudopy = std::string(argv[0]) + ".py";
    execvp(mysudopy.c_str(), argv);
}
