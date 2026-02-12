#define PERIPH_BASE     0x40000000UL
#define APB2PERIPH_BASE (PERIPH_BASE + 0x00010000UL)
#define AHBPERIPH_BASE  (PERIPH_BASE + 0x00018000UL)

#define RCC_BASE        (AHBPERIPH_BASE + 0x00009000UL)
#define GPIOC_BASE      (APB2PERIPH_BASE + 0x00001000UL)

#define RCC_APB2ENR     (*(volatile unsigned int*)(RCC_BASE + 0x18))
#define GPIOC_CRH       (*(volatile unsigned int*)(GPIOC_BASE + 0x04))
#define GPIOC_ODR       (*(volatile unsigned int*)(GPIOC_BASE + 0x0C))

void delay(void)
{
    for (volatile int i = 0; i < 500000; i++);
}

int main(void)
{
    /* Enable GPIOC clock */
    RCC_APB2ENR |= (1 << 4);

    /* Clear PC13 config bits */
    GPIOC_CRH &= ~(0xF << 20);

    /* Set PC13 as output 2MHz push-pull */
    GPIOC_CRH |=  (0x2 << 20);

    while (1)
    {
        GPIOC_ODR ^= (1 << 13);
        delay();
    }
}
