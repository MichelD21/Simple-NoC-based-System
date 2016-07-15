/**
*	Calculates and stores the first 30 Fibonacci
*   numbers and stores them in the internal memory,
*   starting at word location 25 (byte loaction 100)
*/

int main() {

	unsigned int *ptr;
	int a, b;

	/* RAM */
	ptr = (unsigned int *)0x64;	// RAM[100]

	a = 0;	// First number
	b = 1;	// Second number

	*ptr = a;	// Stores the first number
	*ptr++ = b;	// Stores the second number


	/* Stores the remaining numbers */
	for (int i = 0; i < 30; i++) {
		*ptr = a + b;
	 	a = b;
 		b = *ptr;
 		ptr++;
	}


	return 0;
}
