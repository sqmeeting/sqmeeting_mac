//
//  common.h
//  For lib macShareAppStaticLib
//
//  Created by yingyong.Mao on 2022/3/4.
//

#ifndef common_h
#define common_h

#define WEBRTC_MAC = 1
#define WEBRTC_POSIX = 1

// This is copied from MP; should be consistent with MP definition
/*
enum Capture_VideoSampleType {
    SAMPLE_TYPE_NO_TYPE = 0,
    SAMPLE_TYPE_ARGB = 1,
    SAMPLE_TYPE_BGRA = 2 , // ARGB on Windows

    // 4:2:2 packed formats, 16 bits per pixel
    SAMPLE_TYPE_YUY2 = 3, // yuyv
    SAMPLE_TYPE_UYVY = 4, // = kCVPixelFormatType_422YpCbCr8 on Mac

    // 4:2:0 plannar formats, 12 bits per pixel
    SAMPLE_TYPE_I420 = 5, // plane1: YYYY... plane2: UU...  plane3: VV...
    SAMPLE_TYPE_YV12 = 6 , // same as I420, but v plane before u plane
    SAMPLE_TYPE_NV12 = 7, // U/V interleaved. plane1: YYYY... plane2: UVUV...
    SAMPLE_TYPE_NV21 = 8,  // same as NV12, U/V order reversed.
};
*/

enum Capture_VideoSampleType
{
    SAMPLE_TYPE_NO_TYPE = 0,
    SAMPLE_TYPE_ARGB = 1,
    SAMPLE_TYPE_BGRA = 2,
    SAMPLE_TYPE_ABGR = 3,
    SAMPLE_TYPE_RGBA = 4,

    // 4:2:2 packed formats, 16 bits per pixel
    SAMPLE_TYPE_YUY2 = 5, // yuyv
    SAMPLE_TYPE_UYVY = 6, // = kCVPixelFormatType_422YpCbCr8 on Mac

    // 4:2:0 plannar formats, 12 bits per pixel
    SAMPLE_TYPE_I420 = 7, // plane1: YYYY... plane2: UU...  plane3: VV...
    SAMPLE_TYPE_YV12 = 8, // same as I420, but v plane before u plane
    SAMPLE_TYPE_NV12 = 9, // U/V interleaved. plane1: YYYY... plane2: UVUV...
    SAMPLE_TYPE_NV21 = 10, // same as NV12, U/V order reversed.

    SAMPLE_TYPE_H264 = 11,
};

typedef struct CONTENT_CAPS_STRUCT {
    unsigned int    width;
    unsigned int    height;
    int     framerate;
} CONTENT_CAPS_STRUCT;

#endif /* common_h */
