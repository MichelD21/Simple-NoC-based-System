/* ---- IO Device Locations ---- */
#define REG32 (volatile unsigned int*)
#define GPIO_OUT (*(REG32 (0xFFFFFE020)))
#define GPIO_IN  (*(REG32 (0xFFFFFE024)))

#define TO_INTEGER(x)   (0x7FF & ((x.stall_go_out<<10)|(x.tx<<9)|(x.eop_out<<8)|(x.data_out)))

#define N 10

#define WIDTH 256
#define HEIGHT 256

struct ArkeOutputInterface {
    char data_out;
    char eop_out : 1;
    char tx : 1;
    char stall_go_out : 1;
};

int main(void) {
  
	int i, j, flag = 0;
	struct ArkeOutputInterface arke_oif;
	
	int stall_go_in;
	stall_go_in = ((GPIO_IN>>10) & 0x1);
	
	// init
				arke_oif.data_out = 0;
				arke_oif.eop_out = 0; 
				arke_oif.tx = 0;
				arke_oif.stall_go_out = 1;
				
				GPIO_OUT = TO_INTEGER(arke_oif);
	
	while(1) {
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
				if (flag == 0)
					arke_oif.data_out = 0;
				else
					arke_oif.data_out = 255;
				
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
			
		if (flag == 0)
			flag = 1;
		else
			flag = 0;
	}
	
return 0;

}