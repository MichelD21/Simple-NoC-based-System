#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define BITMAP_FILE_HEADER_SIZE 14 // Bytes

/* Bitmap file info */
struct BitmapFileHeader {
    unsigned char signature[2];
    unsigned int fileSize;
    unsigned char reserved[4];
    unsigned int dataOffset;    // Points the first image pixel
};     

/* Bitmap information header */
struct DIBHeader {
    unsigned int headerSize;
    unsigned int width;
    unsigned int height;
    unsigned short int planes;
    unsigned short int bitCount;  // Bits per pixel
    unsigned int compression;
    unsigned int imageSize;     // in pixels (width * height)
    unsigned int XpixelsPerM;   // Horizontal resolution: Pixels/meter
    unsigned int YpixelsPerM;   // Vertical resolution: Pixels/meter
    unsigned int colorsUsed;
    unsigned int colorsImportant;
};

void ReadBitmapFileHeader(struct BitmapFileHeader *bmpFileHeader, FILE *bmpFile) {
        
    fseek(bmpFile, 0, SEEK_SET);    // Seeks the file begin
    
    fread(&bmpFileHeader->signature, 1, sizeof(bmpFileHeader->signature), bmpFile);
    fread(&bmpFileHeader->fileSize, 1, sizeof(bmpFileHeader->fileSize), bmpFile);
    fread(&bmpFileHeader->reserved, 1, sizeof(bmpFileHeader->reserved), bmpFile);
    fread(&bmpFileHeader->dataOffset, 1, sizeof(bmpFileHeader->dataOffset), bmpFile);
    
}

void ReadDibHeader(struct DIBHeader *imageHeader, FILE *bmpFile) {
    
    fseek(bmpFile, BITMAP_FILE_HEADER_SIZE, SEEK_SET); // Seeks the begin of DIB Header
    
    fread(&imageHeader->headerSize, 1, sizeof(imageHeader->headerSize), bmpFile);
    fread(&imageHeader->width, 1, sizeof(imageHeader->width), bmpFile);
    fread(&imageHeader->height, 1, sizeof(imageHeader->height), bmpFile);
    fread(&imageHeader->planes, 1, sizeof(imageHeader->planes), bmpFile);
    fread(&imageHeader->bitCount, 1, sizeof(imageHeader->bitCount), bmpFile);
    fread(&imageHeader->compression, 1, sizeof(imageHeader->compression), bmpFile);
    fread(&imageHeader->imageSize, 1, sizeof(imageHeader->imageSize), bmpFile);
    fread(&imageHeader->XpixelsPerM, 1, sizeof(imageHeader->XpixelsPerM), bmpFile);
    fread(&imageHeader->YpixelsPerM, 1, sizeof(imageHeader->YpixelsPerM), bmpFile);
    fread(&imageHeader->colorsUsed, 1, sizeof(imageHeader->colorsUsed), bmpFile);
    fread(&imageHeader->colorsImportant, 1, sizeof(imageHeader->colorsImportant), bmpFile);
}

int main(int argc, char *argv[]) {

    FILE *bmpFile;
	FILE *txtFile;
    unsigned char *image;
	unsigned char *packet;
    int x, y, i, rowSize;
	unsigned long packetSize;
        
    struct BitmapFileHeader bmpFileHeader;
    struct DIBHeader imageHeader;
	
	txtFile = fopen(argv[2], "wb");
    
    if (argc < 3) {
        printf("Usage: %s <file_name>.bmp <file_name>.bin\n", argv[0]);
        return -1;
    }

    bmpFile = fopen(argv[1], "rb");
    if (bmpFile == NULL) {
        printf("Can't open %s\n", argv[1]);
        return 1;
    }
	
	ReadBitmapFileHeader(&bmpFileHeader,bmpFile);
	ReadDibHeader(&imageHeader,bmpFile);
	
	/* Allocates memory to store the image */
    image = (unsigned char *)malloc(imageHeader.imageSize); 
    
    /* Seeks the begin of image on bmp file */
    fseek(bmpFile, bmpFileHeader.dataOffset, SEEK_SET);
	   
    /* Reads the image */
    fread(image, 1, imageHeader.imageSize, bmpFile);  
    fclose(bmpFile);
	
	/* Get real image width in file (formatting zeroes on BMP) */
	rowSize = 4*floor(((imageHeader.bitCount*imageHeader.width)+31)/32);
	
	packetSize = imageHeader.height*imageHeader.width + 9;
	packet = (unsigned char *)malloc(packetSize);
	
	packet[0] = (packetSize >> 24) & 0x000000FF;
	packet[1] = (packetSize >> 16) & 0x000000FF;
	packet[2] = (packetSize >> 8) & 0x000000FF;
	packet[3] = packetSize & 0x000000FF;
	packet[4] = 3;
	packet[5] = 0;
	packet[6] = 0;
	packet[7] = imageHeader.height;
	packet[8] = imageHeader.width;
	
	/*** Extracts the image pixels ***/
	
	i = 0;
	for(y=imageHeader.height-1; y>=0; y--) {

		for(x=0; x<rowSize; x++) {
			if ( x<imageHeader.width ) {
				packet[i + 9] = image[x + (y*rowSize)];
				i++;
			}
		}
	}
	
	fwrite(packet,1,(9 + imageHeader.width*imageHeader.height),txtFile);
	
	free((void*) packet);
	free((void*) image);
	
	fclose(txtFile);
    
    return 0;
}
