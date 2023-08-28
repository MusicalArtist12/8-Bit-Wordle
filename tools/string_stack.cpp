/*  Julia Abdel-Monem
    June 5, 2023

    Converts a string to a series of avr instructions to push ASCII values onto the stack,
    so that when popped, it'll appear in the order that it would be read.

    ends the string with a 0x00 character, end of array essentially. 

*/

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
    std::string str;

    std::cout << "enter the string to convert: ";
    getline(std::cin, str, '\n');

    node* head = NULL;

    char* c = &str[0];
    while(*c != '\0') {
        std::string value = "ldi r16, " + to_hex((int)*c) + "; char = " + *c + "\n" + "push r16" + "\n\n";
        c++;

        if(head == NULL) {
            head = new node(value);
            head->next = NULL;
        } else {
            node* n = new node(value);
            n->next = head;
            head = n;
        }


    }

    std::string value = "ldi r16, ";
    value += "0x00";
    value += '\n';
    value += "push r16";
    value += "\n\n";
    
    {
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