/* ---- IO Device Locations ---- */
#define REG32 (volatile unsigned int*)
#define GPIO_OUT (*(REG32 (0xFFFFFE020)))
#define GPIO_IN  (*(REG32 (0xFFFFFE024)))

#define TO_INTEGER(x)   (0x7FF & ((x.stall_go_out<<10)|(x.tx<<9)|(x.eop_out<<8)|(x.data_out)))

#define N 10


struct ArkeOutputInterface {
    char data_out;
    char eop_out : 1;
    char tx : 1;
    char stall_go_out : 1;
};


int main(void) {
  
    struct ArkeOutputInterface arke_oif;
	
	while(1) {
		for(char i=0; i<N; i++) {
			
			arke_oif.data_out = 0;
			arke_oif.eop_out = 0; 
			arke_oif.tx = 0;
			arke_oif.stall_go_out = 1;
			
			GPIO_OUT = TO_INTEGER(arke_oif);
		  
			arke_oif.data_out = 3;
			arke_oif.tx = 1;
			
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;
			
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.data_out = i;
			arke_oif.tx = 1;
			
			arke_oif.eop_out = 1;
			
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			arke_oif.tx = 0;
			arke_oif.eop_out = 0;
			
			GPIO_OUT = TO_INTEGER(arke_oif);
			
			for(int j=0; j<10; j++)
			{
				__asm__("");
			}
		}
    }
    
  
  return 0;

}