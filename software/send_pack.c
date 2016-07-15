


/* ---- IO Device Locations ---- */
#define REG32 (volatile unsigned int*)
#define GPIO_OUT (*(REG32 (0xFFFFFE020)))
#define GPIO_IN  (*(REG32 (0xFFFFFE024)))


// system has to wait for a stall_go from gpio_in
// once it manifests, GPIO_OUT outputs the result
// which should be either the least significant flit
// or the full 32 bit.

int main(void)
{

  
  //sg tx eop 00001111
  // header + tx
  GPIO_OUT = 0x200 | 0x0F;
  
  GPIO_OUT = 0x200 | 0x01;  
  
  GPIO_OUT = 0x200 | 0x02;
  
  GPIO_OUT = 0x300 | 0x03;
  
  GPIO_OUT = 0;
  
  
}
