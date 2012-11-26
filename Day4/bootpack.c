#include <stdio.h>


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

void io_hlt(void);
void io_out8(int, int);
int io_load_eflags(void);
void io_store_eflags(int);
void io_cli(void);

//Internal Functions:
void init_palette(void);
void set_palette(int, int, unsigned char *);
void fill_rectangle8(unsigned char *, int, unsigned char, int, int, int, int);
void init_desktop(unsigned char* vram, short xsize, short ysize);
void putFont8(unsigned char *vram, int xsize, int x, int y, char color, char *font);
void putFonts8_asc(char *vram, int xsize, int x, int y, char color, unsigned char *s);
void init_mouse_cursor8(char *mouse, char bc);
void putblock8_8(char *vram, int vxsize, int pxsize, int pysize, int px0, int py0, char *buf, int bxsize);

/* Boot info struct */
typedef struct BOOTINFO
{
	char cyls, leds, vmode, reserve;
	short scrnx, scrny;
	char *vram;
}bootInfo;

/*****************************************/
/*                 MAIN                  */
/*****************************************/
void HariMain(void)
{
	bootInfo *binfo;
	extern char hankaku[4096];

	init_palette();

	binfo = (bootInfo *)0xff0;

	init_desktop(binfo->vram, binfo->scrnx, binfo->scrny);
	char *str = "hello my dear OS!";
	char *scrnx, *scrny;
	sprintf(scrnx, "scrnx = \"%d\"", binfo->scrnx);
	putFonts8_asc(binfo->vram, binfo->scrnx, 8, 8, COL8_FFFFFF, scrnx);
	sprintf(scrny, "scrny = \"%d\"", binfo->scrny);
	putFonts8_asc(binfo->vram, binfo->scrnx, 8, 26, COL8_FFFFFF, scrny);

	char mcursor[256];
	init_mouse_cursor8(mcursor, COL8_008484);
	putblock8_8(binfo->vram, binfo->scrnx, 16, 16, 50, 50, mcursor, 16);

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

void init_desktop(unsigned char* vram, short xsize, short ysize)
{
	fill_rectangle8(vram, xsize, COL8_008484,  0,           0, xsize - 1, ysize -  1);
	fill_rectangle8(vram, xsize, COL8_FFFFFF,  0, ysize - 25, xsize - 1, ysize - 25);
	fill_rectangle8(vram, xsize, COL8_C6C6C6,  0, ysize - 24, xsize - 1, ysize -  1);

	fill_rectangle8(vram, xsize, COL8_FFFFFF,  3, ysize - 21, 59, ysize - 21);
	fill_rectangle8(vram, xsize, COL8_FFFFFF,  2, ysize - 21,  2, ysize -  4);
	fill_rectangle8(vram, xsize, COL8_848484,  3, ysize -  4, 59, ysize -  4);
	fill_rectangle8(vram, xsize, COL8_848484, 59, ysize - 20, 59, ysize - 5);
	fill_rectangle8(vram, xsize, COL8_000000,  2, ysize -  3, 59, ysize - 3);
	fill_rectangle8(vram, xsize, COL8_000000, 60, ysize - 21, 60, ysize - 3);

	fill_rectangle8(vram, xsize, COL8_848484, xsize - 47, ysize - 21, xsize -  4, ysize - 21);
	fill_rectangle8(vram, xsize, COL8_848484, xsize - 47, ysize - 20, xsize - 47, ysize -  4);
	fill_rectangle8(vram, xsize, COL8_FFFFFF, xsize - 47, ysize -  3, xsize -  4, ysize -  3);
	fill_rectangle8(vram, xsize, COL8_FFFFFF, xsize -  3, ysize - 21, xsize -  3, ysize -  3);
}

void putFont8(unsigned char *vram, int xsize, int x, int y, char color, char *font)
{
	int i;
	char *p, d;
	for( i = 0; i < 16; i ++)
	{
		p = vram + (y + i) * xsize + x;
		d = font[i];
		if ((d & 0x80) != 0) { p[0] = color; }
		if ((d & 0x40) != 0) { p[1] = color; }
		if ((d & 0x20) != 0) { p[2] = color; }
		if ((d & 0x10) != 0) { p[3] = color; }
		if ((d & 0x08) != 0) { p[4] = color; }
		if ((d & 0x04) != 0) { p[5] = color; }
		if ((d & 0x02) != 0) { p[6] = color; }
		if ((d & 0x01) != 0) { p[7] = color; }
	}
}

void putFonts8_asc(char *vram, int xsize, int x, int y, char color, unsigned char *s)
{
	extern char hankaku[4096];
	for(; *s != 0x00; s++)
	{
		putFont8(vram, xsize, x, y, color, hankaku + *s * 16);
		x += 8;
	}
}

//bc: background color
void init_mouse_cursor8(char *mouse, char bc)
{
	static char cursor[16][16] = 
	{
		"**************..",
		"*00000000000*...",
		"*0000000000*....",
		"*000000000*.....",
		"*00000000*......",
		"*0000000*.......",
		"*0000000*.......",
		"*00000000*......",
		"*0000**000*.....",
		"*000*..*000*....",
		"*00*....*000*...",
		"*0*......*000*..",
		"**........*000*.",
		"*..........*000*",
		"............*00*",
		".............***",
	};
	int x, y;

	for (y = 0; y < 16; y++)
	{
		for(x = 0; x < 16; x++)
		{
			if (cursor[y][x] == "*")
			{
				mouse[y * 16 + x] = COL8_000000;
			}
			if (cursor[y][x] == "0")
			{
				mouse[y * 16 + x] = COL8_FFFFFF;
			}
			if (cursor[y][x] == ".")
			{
				mouse[y * 16 + x] = bc;
			}
		}
	}
}

void putblock8_8(char *vram, int vxsize, int pxsize, int pysize, int px0, int py0, char *buf, int bxsize)
{
	int x, y;
	char *temp;
	for(y = 0; y < pysize; y++)
	{
		for(x = 0; x < pxsize; x ++)
		{
			vram[(py0+y) * vxsize + (px0 + x)] = buf[y * bxsize + x];
			sprintf(temp, "%d", buf[y * bxsize +x]);
			putFonts8_asc(vram, vxsize, 8 * (y*16 + x), 50, COL8_000000, temp);
		}
	}
}