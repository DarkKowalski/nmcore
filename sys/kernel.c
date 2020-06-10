#define VGA_ADDR       0xb8000
#define VGA_LIGHT_GRAY 7

void print(char *str)
{
    unsigned char *video = ((unsigned char *)VGA_ADDR);
    while (*str != '\0')
    {
        *(video++) = *str++;
        *(video++) = VGA_LIGHT_GRAY;
    }
}

void kernel_main(void)
{
    print("Hello Kernel World!");

    for (;;)
        ;
}