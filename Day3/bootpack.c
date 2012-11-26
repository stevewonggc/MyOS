#define COL8_000000 0
#define COL8_FF0000 1
#define COL8_00FF00 2
#define COL8_FFFF00 3
#define COL8_0000FF 4
#define COL8_FF00FF 5
#define COL8_00FFFF 6
#define COL8_FFFFFF 7
#define COL8_C6C6C6 8
#define COL8_840000 9
#define COL8_008400 10
#define COL8_848400 11
#define COL8_000084 12
#define COL8_840084 13
#define COL8_008484 14
#define COL8_848484 15

#define X_SIZE 320
#define Y_SIZE 200


void io_hlt(void);
void io_out8(int, int);
int io_load_eflags(void);
void io_store_eflags(int);
void io_cli(void);

//Internal Functions:
void init_palette(void);
void set_palette(int, int, unsigned char *);
void fill_rectangle8(unsigned char *, int, unsigned char, int, int, int, int);
void HariMain(void)
{
	char *p;
    p = (char *) 0xa0000;

	init_palette();

	fill_rectangle8(p, X_SIZE, COL8_008484,  0,           0, X_SIZE - 1, Y_SIZE -  1);
	//fill_rectangle8(p, X_SIZE, COL8_C6C6C6, 0, Y_SIZE - 25, X_SIZE - 1, Y_SIZE - 25);
	fill_rectangle8(p, X_SIZE, COL8_FFFFFF,  0, Y_SIZE - 25, X_SIZE - 1, Y_SIZE - 25);
	fill_rectangle8(p, X_SIZE, COL8_C6C6C6,  0, Y_SIZE - 24, X_SIZE - 1, Y_SIZE -  1);

	fill_rectangle8(p, X_SIZE, COL8_FFFFFF,  3, Y_SIZE - 21, 59, Y_SIZE - 21);
	fill_rectangle8(p, X_SIZE, COL8_FFFFFF,  2, Y_SIZE - 21,  2, Y_SIZE -  4);
	fill_rectangle8(p, X_SIZE, COL8_848484,  3, Y_SIZE -  4, 59, Y_SIZE -  4);
	fill_rectangle8(p, X_SIZE, COL8_848484, 59, Y_SIZE - 20, 59, Y_SIZE - 5);
	fill_rectangle8(p, X_SIZE, COL8_000000,  2, Y_SIZE -  3, 59, Y_SIZE - 3);
	fill_rectangle8(p, X_SIZE, COL8_000000, 60, Y_SIZE - 21, 60, Y_SIZE - 3);

	fill_rectangle8(p, X_SIZE, COL8_848484, X_SIZE - 47, Y_SIZE - 21, X_SIZE -  4, Y_SIZE - 21);
	fill_rectangle8(p, X_SIZE, COL8_848484, X_SIZE - 47, Y_SIZE - 20, X_SIZE - 47, Y_SIZE -  4);
	fill_rectangle8(p, X_SIZE, COL8_FFFFFF, X_SIZE - 47, Y_SIZE -  3, X_SIZE -  4, Y_SIZE -  3);
	fill_rectangle8(p, X_SIZE, COL8_FFFFFF, X_SIZE -  3, Y_SIZE - 21, X_SIZE -  3, Y_SIZE -  3);
	

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
	for (i = start; i <= end; i ++)
	{
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}
	io_store_eflags(eflags); /* recover the value of interuption permision flags */
	return;
}

void fill_rectangle8(unsigned char *vram, int x_size, unsigned char color, int x0, int y0, int x1, int y1)
{
	int x, y;
	for(y = y0; y <= y1; y ++)
	{
		for(x = x0; x <= x1; x++)
		{
			*(vram + y*x_size + x) = color;
		}
	}
}