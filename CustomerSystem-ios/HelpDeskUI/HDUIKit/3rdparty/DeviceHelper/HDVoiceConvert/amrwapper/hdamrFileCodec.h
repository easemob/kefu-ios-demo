//
//  amrFileCodec.h
//  amrDemoForiOS
//
//  Created by Tang Xiaoping on 9/27/11.
//  Copyright 2011 test. All rights reserved.
//
#ifndef hdamrFileCodec_h
#define hdamrFileCodec_h
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "hdinterf_dec.h"
#include "hdinterf_enc.h"

#define HDAMR_MAGIC_NUMBER "#!AMR\n"
#define HDMP3_MAGIC_NUMBER "ID3"

#define HDPCM_FRAME_SIZE 160 // 8khz 8000*0.02=160
#define HDMAX_AMR_FRAME_SIZE 32
#define HDAMR_FRAME_COUNT_PER_SECOND 50

typedef struct
{
	char chChunkID[4];
	int nChunkSize;
}HDEM_XCHUNKHEADER;

typedef struct
{
	short nFormatTag;
	short nChannels;
	int nSamplesPerSec;
	int nAvgBytesPerSec;
	short nBlockAlign;
	short nBitsPerSample;
}HDEM_WAVEFORMAT;

typedef struct
{
	short nFormatTag;
	short nChannels;
	int nSamplesPerSec;
	int nAvgBytesPerSec;
	short nBlockAlign;
	short nBitsPerSample;
	short nExSize;
}HDEM_WAVEFORMATX;

typedef struct
{
	char chRiffID[4];
	int nRiffSize;
	char chRiffFormat[4];
}HDEM_RIFFHEADER;

typedef struct
{
	char chFmtID[4];
	int nFmtSize;
	HDEM_WAVEFORMAT wf;
}HDEM_FMTBLOCK;

// WAVE audio processing frequency is 8khz
// audio processing unit = 8000*0.02 = 160 (decided by audio processing frequency)
// audio channels 1 : 160
//        2 : 160*2 = 320
// bps decides the size of processing sample
// bps = 8 --> 8 bits
//       16 --> 16 bit
int HDEM_EncodeWAVEFileToAMRFile(const char* pchWAVEFilename, const char* pchAMRFileName, int nChannels, int nBitsPerSample);

int HDEM_DecodeAMRFileToWAVEFile(const char* pchAMRFileName, const char* pchWAVEFilename);

int HDisMP3File(const char *filePath);

int HDisAMRFile(const char *filePath);
#endif
