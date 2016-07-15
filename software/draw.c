/* ---- IO Device Locations ---- */
#define REG32 (volatile unsigned int*)
#define GPIO_OUT (*(REG32 (0xFFFFFE020)))
#define GPIO_IN  (*(REG32 (0xFFFFFE024)))

#define TO_INTEGER(x)   (0x7FF & ((x.stall_go_out<<10)|(x.tx<<9)|(x.eop_out<<8)|(x.data_out)))

#define stall_go_in (GPIO_IN>>10 & 0x1)

#define OUTPUT		while(stall_go_in != 1); GPIO_OUT = TO_INTEGER(arke_oif);

#define N 10


struct ArkeOutputInterface {
    char data_out;
    char eop_out : 1;
    char tx : 1;
    char stall_go_out : 1;
};

int main(void) {
  
	int i, j;
	i = j = 0;
    struct ArkeOutputInterface arke_oif;
	
		for(i=0; i<256; i++) {
			for(j=0; j<256; j++) {
				
				// init
				arke_oif.data_out = 0;
				arke_oif.eop_out = 0; 
				arke_oif.tx = 0;
				arke_oif.stall_go_out = 1;
			
				OUTPUT	
				
				// header
				arke_oif.data_out = 3;
				arke_oif.tx = 1;
				
				OUTPUT
				
				arke_oif.tx = 0;
				
				OUTPUT
				
				// address x
				arke_oif.data_out = 128;
				arke_oif.tx = 1;
				
				OUTPUT
				
				arke_oif.tx = 0;
				
				OUTPUT
				
				// address y
				
				arke_oif.data_out = 128;
				arke_oif.tx = 1;
				
				OUTPUT
				
				arke_oif.tx = 0;
				
				OUTPUT
				
				// pixel
				
				arke_oif.data_out = 255;
				arke_oif.tx = 1;
				arke_oif.eop_out = 1;
				
				OUTPUT
				
				arke_oif.tx = 0;
				arke_oif.eop_out = 0;
			
				OUTPUT
				
			}
		}
  return 0;

}