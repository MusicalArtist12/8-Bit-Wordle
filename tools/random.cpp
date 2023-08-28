/*
    algorithm that generates a sequence of numbers whose properties approximate the properties of sequences
    of true random sequences.

    PRNG's seed

    careful mathematical analysis is required to have any confidence in the resultss

    Artifacts 
        shorter-than-expected seeds
        lack of uniformity
        correlation of successive values
        poor dimensional distribution
        distances between numbers are distributed differently from those in a true random distribution

    linear congruential generator
        java, until 2020
        Mersenne Twister - good algorithm using this method
        xorshift generators - when combined with nonlinear operation tend to operate well
        WELL family of generators

    four criteria
        high probability that generated sequences are different
        indistinguisible from truely random number sequences
        should be impossible to guess the next values in the sequence

    
    Early approaches
        middle-square method (neumann!!!)
            let n be any number. sequare it. remove the middle digits. that is the random number.
            this random number is the next seed.

            1111^2 = 1234321 = 01234321. 01 2343 21, 2343 is the random number. 
            2343^2 = 5489649 = 05489649. 05 4896 49 

            all sequences eventually repeat. 0000, for instance is a sequence of 1 value

            combining with the weyl sequence has proven to be powerful

            

    Mersenne Twister
        period length is chosen to be a mersenne prime (a prime number 2^n -1 )

        Most common use of the MT is the MT19337, which uses 2^19937-1.

        used by Ruby, Python, Glib, Excel, Matlab, its also available in the C++ stl

        Permissively Licensed

        its 2.5 KiB unless TinyMT variant is used...
            TinyMT uses only 127 bits!, only a period of 2^127-1.

        Poor Diffusion (can take a while before it passes randomness tests)

        not cryptographically secure...

    Xorshift
        linear-feedback shift registers
            the current number is some linear change from the last one

        generate next number in the sequence by repeatedl taking the xor of a number witha a bitshifted version of itself

        1. 0100 1001
           1001 0010

        2. 1101 1011
           1011 0110 
        
        3. 0110 1101 
            ... 

        this, by itself does not pass every statistical test without further refinement. 
        weakness is ammended by combining it with a non-linear funcitoon 


        xorwow - nvidia CUDA
        xorshift* - 
        xorshift+ - (proposed by MT inventors!)
        

    CBRNG
        
*/


/*
    Build a linear feedback shift register

    let F(n) = ((F(n-1) << 2) + F(n-2)) xor F(n-1)
*/
#include <iostream>
#include <random>
#include <ctime>
#include <fstream>

/*
This is a terrible algorithm for many reasons. the main one being generated[1000]

int seed = 255;

int generated[1000];


int our_random(int n) {
    int value = seed;

    if(n > 1) {
        int a = generated[n-1] << 2;
        int b = generated[n-2] ^ our_random(n-1);
        value = a + b;

    }
    generated[n] = value % 256;

    return value % 256;

}
*/

void toBinary(int n, int x[8]) {
    // x[8] = MSB
    for(int i = 8; i >= 0; i--){
        x[i] = n % 2;
        n = n / 2;
        std::cout << x[i];
    }

    std::cout << std::endl;
}

int toDecimal(int n[8]) {
    int value = 0;
    int place = 1;

    for(int i = 0; i < 8; i++) {
        value += n[i] * place;
        place *= 2;
    }

    return value;
}

int previous;

bool loop = true;

std::fstream fout;

int LFSR() {
    int current = previous >> 1;

    if( (previous >> 0) % 2 ^
        (previous >> 2) % 2 ^ 
        (previous >> 3) % 2 ^ 
        (previous >> 4) % 2 ){
        
        current += 128;
    } 

    loop = !(previous == current);
    previous = current % 256;

    return current;
}

int randomLFSR() {
    int bin[8];

    for(int i = 0; i < 8; i++) {
        int n = LFSR() & 1;
        bin[i] = n;
    }
    
    return toDecimal(bin);
}

int checkRandom(int seed, bool print = false) {
    int probability_array[255];

    for(int i = 0; i < 255; i++) {
        probability_array[i] = 0;
    }

    previous = seed;

    int count = 0;
    do {
        if(print) std::cout << LFSR() << std::endl;
        else LFSR();

        count++;
        
        // repeat before complete cycle check
        if(probability_array[previous] == 1) {
            loop = false;
        }

        probability_array[previous]++;

    // check for loop bool and # of repetitions
    } while(loop && count < 255);

    std::cout << "COUNT: " << count << std::endl;
    
    if(print) {
        for(int i = 0; i < 255; i++) {
            if(probability_array[i] > 0) continue;
            std::cout << i << ": " << probability_array[i] << std::endl;
        }
    }

    return count;
}

int main() {
    std::cout << "enter a seed: ";
    int n;
    std::cin >> n;

    previous = n % 256;

    for(int i = 0; i < 256; i++) {
        std::cout << randomLFSR() % 64 << std::endl;
    } 

}
