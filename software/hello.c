/* ---- IO Device Locations ---- */
#define REG32 (volatile unsigned int*)
#define GPIO_OUT (*(REG32 (0xFFFFFE020)))
#define GPIO_IN  (*(REG32 (0xFFFFFE024)))

#define TO_INTEGER(x)   (0x7FF & ((x.stall_go_out<<10)|(x.tx<<9)|(x.eop_out<<8)|(x.data_out)))

#define new_line 	    12

struct ArkeOutputInterface {
    char data_out;
    char eop_out : 1;
    char tx : 1;
    char stall_go_out : 1;
};

int main(void) { 
 
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
		
		// header
		arke_oif.data_out = 2;
		arke_oif.tx = 1;
		
		stall_go_in = ((GPIO_IN>>10) & 0x1);
		while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
		GPIO_OUT = TO_INTEGER(arke_oif);
		
		arke_oif.tx = 0;
		
		GPIO_OUT = TO_INTEGER(arke_oif);
		
		// payload 
			arke_oif.data_out = 'h';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = 'e';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = 'l';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = 'l';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = 'o';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0; 

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = ' ';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = 'w';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = 'o';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = 'r';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = 'l';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = 'd';
			arke_oif.tx = 1;

			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = new_line;
			arke_oif.tx = 1;
			arke_oif.eop_out = 1;
			
			stall_go_in = ((GPIO_IN>>10) & 0x1);
			while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;
			arke_oif.eop_out = 0;

			GPIO_OUT = TO_INTEGER(arke_oif);
				
	}
		
	return 0;

}