SECTIONS
{
  . = 0x7c00;
  .text : { *(.text) }
  . = 0x8000;
  .bss : { *(.bss) }
}
