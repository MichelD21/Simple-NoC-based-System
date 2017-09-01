#include <stdio.h>
#include <stdlib.h>
#include <string.h>
  
void TextSpeichern (FILE *dateizeiger)
{
   char buffer[80] = "";
 
   printf ("\nDone!\n\n");
 
   fgets (buffer, 80, stdin);   /* von der Tastatur lesen (stdin) */
   return;
 
}
 
//**********************************************************************
// Hauptfunktion
//**********************************************************************
int main(int argc, char *argv[])
{
  FILE * pFile;
  char filename[80] = "a.out";
  long lSize;
  int m = 0;
  int adr_start;
  unsigned char * buffer;
  size_t result;
  
  FILE *d; // binary output file


  if (argc > 1)
  {
     while(argv[1][m] != '\0')
     {
       filename[m] = argv[1][m];
       m++;
     }
  }

  //system("color 0a");

  pFile = fopen (filename , "rb" );
  if (pFile==NULL)
  {
   printf("Cannot open file 'a.out'\n");
   exit (1);
  }

  // obtain file size:
  fseek (pFile , 0 , SEEK_END);
  lSize = ftell (pFile);
  rewind (pFile);

  // allocate memory to contain the whole file:
  buffer = (unsigned char*) malloc (sizeof(unsigned char)*lSize);
  if (buffer == NULL)
  {
   printf("Memory error\n");
   exit (2);
  }

  // copy the file into the buffer:
  result = fread (buffer,1,lSize,pFile);
  if (result != lSize)
  {
   printf("Reading error\n");
   exit (3);
  }

  // Open dat output file
  d = fopen("program_uart.bin","wb+");
  if(d == NULL)
  {
   printf("Error creating binary output file\n");
   exit(11);
  }
  
  if (buffer[45] == 1)
  {
       adr_start = 56;
  }
  else
  {
      adr_start = 88;
  }

  // Beginning of mnemomic part
  unsigned long mnemonic_beginning = 0;
  mnemonic_beginning = ((buffer[adr_start] << 24) | (buffer[adr_start+1] << 16) | (buffer[adr_start+2] << 8) | (buffer[adr_start+3]));
  //printf("Mnemonic start:  %u\n", mnemonic_beginning);

  // Length of mnemonic part
  unsigned long mnemonic_length = 0;
  mnemonic_length = ((buffer[adr_start+12] << 24) | (buffer[adr_start+13] << 16) | (buffer[adr_start+14] << 8) | (buffer[adr_start+15]));
  if(mnemonic_length == 0)
  {
   printf("Invalid assembler file\n"); //x38 x58
   exit(4);
  }

  if (mnemonic_length == 0)
  {
   printf("Assembler file is empty\n");
   exit(5);
  }

  printf("Program start: 0x%.8X\n", mnemonic_beginning);
  printf("Program size:  0x%.8X\n", mnemonic_length-4);

	int j = mnemonic_beginning;
	char header = 0x00;		// target address
	char byte[4];
	unsigned int size;
	unsigned int payload_size = mnemonic_length + 1;	// total packet size (payload + header)		
	unsigned int b0,b1,b2,b3;
	
	// endian conversion
	b0 = (payload_size & 0x000000ff) << 24u;
	b1 = (payload_size & 0x0000ff00) << 8u;
	b2 = (payload_size & 0x00ff0000) >> 8u;
	b3 = (payload_size & 0xff000000) >> 24u;

	size = b0 | b1 | b2 | b3;
	
	// packet frame : size(4B) + header(1B) + payload(n*4B)
	fwrite(&size,4,1,d);
	fwrite(&header,1,1,d);
  
	while (j != (mnemonic_length + mnemonic_beginning))
	{
		fwrite(&buffer[j],1,1,d);
		j++;
	}
	
	fclose(pFile);
	fclose(d);
	free(buffer);
	
	return 0;
}
