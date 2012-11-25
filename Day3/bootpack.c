void io_hlt(void);
void io_out8(int, int);
int io_load_eflags(void);
void io_store_eflags(int);
void io_cli(void);

//Internal Functions:
void init_palette(void);
void set_palette(int, int, unsigned char *);
void HariMain(void)
{
	int i;
	init_palette();
	for(i = 0xa0000; i < 0xaffff; i++)
	{
		*((char *) i) = i & 0xf;
	}

	for( ; ; )
	{
		io_hlt();
	}
}

void init_palette(void)
{
	static unsigned char table_rgb[16 * 3] = 
	{
		0x00, 0x00, 0x00, /*  0 black */
		0xff, 0x00, 0x00, /*  1 bright red */
		0x00, 0xff, 0x00, /*  2 bright green */
		0xff, 0xff, 0x00, /*  3 bright yellow */
		0x00, 0x00, 0xff, /*  4 bright blue */
		0xff, 0x00, 0xff, /*  5 bright purple */
		0x00, 0xff, 0xff, /*  6 light bright blue */
		0xff, 0xff, 0xff, /*  7 white */
		0xc6, 0xc6, 0xc6, /*  8 bright gray */
		0x84, 0x00, 0x00, /*  9 dark red */
		0x00, 0x84, 0x00, /* 10 dark breen */
		0x84, 0x84, 0x00, /* 11 dark yellow */
		0x00, 0x00, 0x84, /* 12 dark blue */
		0x84, 0x00, 0x84, /* 13 dark purple */
		0x00, 0x84, 0x84, /* 14 light dark blue */
		0x84, 0x84, 0x84  /* 15 dark gray */
	};
	set_palette(0, 15, table_rgb);
}

void set_palette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = io_load_eflags(); /* record the value of interuption permision flags */
	io_cli(); /* forbidden the interuption */

	io_out8(0x03c8, start);
	for (i = start; i < end; i ++)
	{
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}
	io_store_eflags(eflags); /* recover the value of interuption permision flags */
	return;
}