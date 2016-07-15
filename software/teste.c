/* ---- IO Device Locations ---- */
#define REG32 (volatile unsigned int*)
#define GPIO_OUT (*(REG32 (0xFFFFFE020)))
#define GPIO_IN  (*(REG32 (0xFFFFFE024)))

#define TO_INTEGER(x)   (0x7FF & ((x.stall_go_out<<10)|(x.tx<<9)|(x.eop_out<<8)|(x.data_out)))

#define WIDTH 32
#define HEIGHT 24

unsigned char image[] = { 0x09, 0x09, 0xEC, 0xEC, 0xEC, 0xEC, 0xEC, 0xF4, 0xF5, 0xF5, 0xF5, 0xF5, 0x09, 0x09, 0x09, 0xF6, 0xF6, 0x09, 0x09, 0x09, 0x09, 0x07, 0x09, 0x09, 0xF6, 0xF6, 0xF6, 0xF6, 0xF6, 0x09, 0x09, 0x09,
0x09, 0x09, 0x09, 0x09, 0xEC, 0xEC, 0xEC, 0xF4, 0xEC, 0xEC, 0xEC, 0xF5, 0xF4, 0xF5, 0x09, 0xA4, 0xA4, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09,
0xF5, 0x09, 0x09, 0x09, 0xF5, 0xF5, 0xF5, 0xF5, 0xF4, 0xF4, 0xF5, 0xEC, 0xEC, 0xEC, 0x92, 0x41, 0x00, 0xA4, 0xED, 0xF4, 0xF4, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09,
0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xF4, 0x09, 0x09, 0x09, 0x09, 0x52, 0x00, 0x00, 0xF7, 0xED, 0xEC, 0xE3, 0xEC, 0xEC, 0xEC, 0xEC, 0xEC, 0xEC, 0xED, 0x09, 0x09, 0x09, 0x09,
0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xF5, 0xF5, 0xF5, 0x09, 0x09, 0x09, 0x09, 0x49, 0x51, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xF4, 0xEC, 0xEC, 0xE3, 0xA3, 0xE3, 0xE3, 0xE4, 0xEC,
0xF5, 0xF5, 0x09, 0xF5, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xEC, 0xE4, 0xEC, 0x09, 0x09, 0xEC, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xF5, 0xF5, 0xEC, 0xEC, 0xEC, 0xEC,
0x09, 0x09, 0x09, 0x09, 0x09, 0xF5, 0xF5, 0xF5, 0xF5, 0x09, 0x09, 0xDA, 0x91, 0x91, 0x89, 0xEC, 0xEC, 0xEC, 0xEB, 0xEC, 0xEC, 0xF5, 0x09, 0xF4, 0xF5, 0x09, 0x09, 0x09, 0x09, 0xEC, 0xEC, 0xEC,
0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xF5, 0xEC, 0xE2, 0xDA, 0x91, 0x40, 0x40, 0xDA, 0x9B, 0xF5, 0xF4, 0xEB, 0xF4, 0xEC, 0xEC, 0xEC, 0xEC, 0x09, 0x09, 0x09, 0x09, 0xF5, 0xEC, 0xEC,
0xF5, 0xF5, 0x09, 0x09, 0x09, 0x09, 0xF4, 0xEC, 0xED, 0xE3, 0xDA, 0xE3, 0x91, 0x48, 0x00, 0x49, 0xEC, 0x09, 0xF4, 0x09, 0x07, 0xF5, 0x09, 0x09, 0xEC, 0xEC, 0xEC, 0xEC, 0xEC, 0xEC, 0xEC, 0x09,
0xF5, 0xF5, 0xED, 0xED, 0xF5, 0xF5, 0xEC, 0xEC, 0xEC, 0x48, 0x48, 0x49, 0x48, 0x00, 0xA3, 0x92, 0x92, 0xEC, 0xEB, 0xA3, 0xA3, 0xE3, 0xF4, 0xEC, 0xEC, 0xEC, 0xEC, 0xEC, 0xE3, 0xE3, 0xE3, 0xE3,
0xF5, 0xED, 0xEC, 0xEC, 0xEC, 0xED, 0xED, 0xED, 0xED, 0x00, 0x00, 0x00, 0x00, 0x00, 0xED, 0x09, 0x89, 0x9A, 0x09, 0x09, 0xEC, 0xE3, 0xE3, 0xEC, 0xE3, 0xE3, 0xEC, 0xEC, 0xEC, 0xEC, 0xF5, 0xF4,
0x09, 0x09, 0xF5, 0xF5, 0xED, 0xED, 0xEC, 0xEC, 0xED, 0x49, 0x00, 0x00, 0x00, 0x00, 0x00, 0xED, 0x09, 0x92, 0xA2, 0x09, 0x09, 0xF5, 0x09, 0x09, 0xEC, 0xE4, 0xEC, 0xEC, 0xE3, 0xE3, 0xEC, 0xEC,
0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xED, 0x00, 0x00, 0x00, 0x00, 0x00, 0x49, 0xED, 0xF5, 0x9B, 0x4A, 0xE5, 0x07, 0xED, 0xEC, 0xF5, 0xEC, 0xED, 0xF5, 0xEC, 0xEC, 0xEC, 0xF5,
0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xF6, 0xA4, 0x00, 0x00, 0x52, 0x00, 0x00, 0x49, 0xF5, 0xF5, 0x52, 0x52, 0xEE, 0x09, 0xF5, 0xF5, 0xED, 0xEC, 0xEC, 0xEC, 0xEC, 0xED, 0xF5,
0xF6, 0xF6, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xA3, 0x00, 0x9B, 0xF6, 0xF5, 0x00, 0x49, 0xF5, 0x09, 0x07, 0xED, 0xED, 0xF5, 0xED, 0xED, 0xEC, 0xEC, 0xEC, 0xEC, 0xEC, 0xEC, 0xEC,
0xFF, 0xFF, 0xF6, 0x09, 0x09, 0x09, 0xF5, 0xF5, 0x09, 0xAC, 0x00, 0x52, 0xF6, 0x09, 0x09, 0x49, 0x00, 0x09, 0x09, 0x09, 0x09, 0x09, 0xF5, 0x09, 0xF5, 0xEC, 0xED, 0xED, 0xED, 0xEC, 0xED, 0xF5,
0x09, 0x09, 0xFF, 0xFF, 0xFF, 0xF6, 0x09, 0x07, 0x07, 0x49, 0x00, 0xE4, 0x09, 0x09, 0x09, 0x51, 0x00, 0xED, 0x09, 0x09, 0x07, 0xF5, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xF5, 0xF5, 0xEC, 0xEC,
0xA3, 0xE3, 0xED, 0x09, 0xF6, 0xF6, 0xF6, 0xFF, 0xED, 0x92, 0xED, 0xED, 0xA3, 0xE3, 0xE3, 0x9A, 0x00, 0xAC, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09,
0xEC, 0xE3, 0x9B, 0xA3, 0xA3, 0xE3, 0xE3, 0xE4, 0xE4, 0xEC, 0xFF, 0xFF, 0x08, 0x09, 0xED, 0x9B, 0x00, 0x92, 0xEC, 0xEC, 0xEC, 0xEC, 0xE3, 0xEC, 0xF5, 0xF5, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09,
0x09, 0x09, 0xED, 0xED, 0xEC, 0xE3, 0x9A, 0x91, 0x49, 0x52, 0x9C, 0xF7, 0x08, 0xF6, 0xFF, 0x07, 0x00, 0x00, 0x48, 0xA3, 0xEC, 0xA3, 0xDB, 0xDA, 0xE3, 0xE3, 0xEB, 0xEB, 0xEC, 0xF5, 0xF4, 0xF5,
0x09, 0x09, 0x09, 0x09, 0x09, 0xF5, 0xF5, 0xF5, 0x51, 0x00, 0x49, 0x52, 0x92, 0x9B, 0xA4, 0xA4, 0x52, 0x53, 0x53, 0xB7, 0xBF, 0xB7, 0x08, 0x07, 0x07, 0xF7, 0xED, 0xF7, 0xE4, 0xE4, 0xE3, 0xE3,
0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x9A, 0x40, 0x91, 0xEC, 0xEC, 0xE3, 0xA3, 0x00, 0x49, 0x52, 0xA5, 0xAF, 0x6E, 0x6F, 0xB7, 0xBF, 0xB7, 0xB7, 0xBF, 0xB7, 0x07, 0xF7, 0xE3, 0xE3,
0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x9A, 0x48, 0xA3, 0xEC, 0xF4, 0x09, 0xA3, 0x00, 0xE3, 0xE4, 0xE4, 0xEC, 0xA4, 0x9B, 0x9B, 0x9A, 0xE3, 0x9B, 0x9B, 0x9B, 0xDB, 0xE3, 0xE3, 0xEC,
0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0xEC, 0x92, 0x49, 0xA4, 0xED, 0xF5, 0xEC, 0x51, 0x52, 0xF5, 0xF5, 0x09, 0x09, 0x09, 0x07, 0x09, 0xF5, 0xEC, 0xEC, 0xE4, 0xEC, 0xEC, 0xEC, 0xEC, 0xE3
 };
 
struct ArkeOutputInterface {
    char data_out;
    char eop_out : 1;
    char tx : 1;
    char stall_go_out : 1;
};

int main(void) {
  
	int i, j;
	struct ArkeOutputInterface arke_oif;
	
	int stall_go_in;
	stall_go_in = ((GPIO_IN>>10) & 0x1);
	
	// init
				arke_oif.data_out = 0;
				arke_oif.eop_out = 0; 
				arke_oif.tx = 0;
				arke_oif.stall_go_out = 1;
				
				GPIO_OUT = TO_INTEGER(arke_oif);
	
	for(i=0; i<HEIGHT; i++) {
		for(j=0; j<WIDTH; j++) {
			
			// header
			arke_oif.data_out = 3;
			arke_oif.tx = 1;
			
			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;
			
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			// line address
			arke_oif.data_out = i;
			arke_oif.tx = 1;
		
			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;
		
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			// column address
			arke_oif.data_out = j;
			arke_oif.tx = 1;
			
			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;
		
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			// pixel
			
			arke_oif.data_out = image[i*WIDTH+j];
											
			arke_oif.tx = 1;
			arke_oif.eop_out = 1;
			
			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;
			arke_oif.eop_out = 0;
		
			GPIO_OUT = TO_INTEGER(arke_oif);
			
		}
	}
	
	while(1) {
		__asm__("");
	}
	
  return 0;

}