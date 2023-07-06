#include <iostream>
#include <string>
#include <sstream>

struct node{
    std::string data;
    node* next = NULL;

    node(std::string value) {
        data = value;
    }
};




std::string to_hex(int n) {
    int a = n/16;
    int b = n % 16;
    std::string hex;

    hex += '0';
    hex += 'x';
    
    if(a > 9) {
        a = a - 9;
        hex += 64 + a;
    } else {
        hex += 48 + a;
    }

    if(b > 9) {
        b = b - 9;
        hex += 64 + b;
    } else {
        hex += 48 + b;
    }

    return hex;

}

int main() {
    char string[] = "Hello World\0";

    int length = 0;

    char* c = &string[0];
    while(*c != '\0') {
        c++;
        length++;
    }

    

    std::string value = "ldi r16, ";
    value += std::to_string(length);
    value += '\n';
    value += "push r16";
    value += "\n\n";

    node* head = new node(value);
    head->next = NULL;


    c = &string[0];
    while(*c != '\0') {
        std::string value = "ldi r16, " + to_hex((int)*c) + "; char = " + *c + "\n" + "push r16" + "\n\n";
        c++;
        length++;

            node* n = new node(value);
            n->next = head;
            head = n;
    }


    node* n = head;
    while(n != NULL) {
        std::cout << n->data;
        n = n->next;
    }
}