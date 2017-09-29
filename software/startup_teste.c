/* ---- IO Device Locations ---- */
#define REG32 (volatile unsigned int*)
#define GPIO_OUT (*(REG32 (0xFFFFFE020)))
#define GPIO_IN  (*(REG32 (0xFFFFFE024)))

#define TO_INTEGER(x)   (0x7FF & ((x.stall_go_out<<10)|(x.tx<<9)|(x.eop_out<<8)|(x.data_out)))

#define newline	    10

struct ArkeOutputInterface {
    char data_out;
    char eop_out : 1;
    char tx : 1;
    char stall_go_out : 1;
};

int main(void) { 
 
	struct ArkeOutputInterface arke_oif;
    
    char uart_str[6] = "start";
    char vga_str[6] = {200,0,0,0,122};
    int i = 0;
    
	int stall_go_in;
	stall_go_in = ((GPIO_IN>>10) & 0x1);
	
	// init
	arke_oif.data_out = 0;
	arke_oif.eop_out = 0;
	arke_oif.tx = 0;
	arke_oif.stall_go_out = 1;
	
	GPIO_OUT = TO_INTEGER(arke_oif);
		
    // VGA packet
    // header
        arke_oif.data_out = 3;
        arke_oif.tx = 1;
        
        stall_go_in = ((GPIO_IN>>10) & 0x1);
        while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
        GPIO_OUT = TO_INTEGER(arke_oif);
        
        arke_oif.tx = 0;
        
        GPIO_OUT = TO_INTEGER(arke_oif);
    
    // config & payload
        for(i=0;i<(sizeof(vga_str)-1);i++) {
            
            arke_oif.data_out = vga_str[i];
            arke_oif.tx = 1;
            if(i==(sizeof(vga_str)-2)) arke_oif.eop_out = 1;

            stall_go_in = ((GPIO_IN>>10) & 0x1);
            while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
            GPIO_OUT = TO_INTEGER(arke_oif);
            
            arke_oif.tx = 0;
            if(i==(sizeof(vga_str)-2)) arke_oif.eop_out = 0;

            GPIO_OUT = TO_INTEGER(arke_oif);
        }
        
    // UART packet   
    // header
        arke_oif.data_out = 2;
        arke_oif.tx = 1;
        
        stall_go_in = ((GPIO_IN>>10) & 0x1);
        while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
        GPIO_OUT = TO_INTEGER(arke_oif);
        
        arke_oif.tx = 0;
        
        GPIO_OUT = TO_INTEGER(arke_oif);
    
    // payload
        for(i=0;i<(sizeof(uart_str)-1);i++) {
            
            arke_oif.data_out = uart_str[i];
            arke_oif.tx = 1;

            stall_go_in = ((GPIO_IN>>10) & 0x1);
            while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
            GPIO_OUT = TO_INTEGER(arke_oif);
            
            arke_oif.tx = 0;

            GPIO_OUT = TO_INTEGER(arke_oif);
        }
        
        arke_oif.data_out = newline;
        arke_oif.tx = 1;
        arke_oif.eop_out = 1;

        stall_go_in = ((GPIO_IN>>10) & 0x1);
        while(stall_go_in != 1) stall_go_in = ((GPIO_IN>>10) & 0x1);
        GPIO_OUT = TO_INTEGER(arke_oif);
        
        arke_oif.tx = 0;
        arke_oif.eop_out = 0;

        GPIO_OUT = TO_INTEGER(arke_oif);
            
	return 0;

}
