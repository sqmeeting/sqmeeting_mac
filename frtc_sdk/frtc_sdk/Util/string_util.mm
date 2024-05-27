#include "string_util.h"
#include <vector>

namespace {

#ifdef __BIG_ENDIAN__
static const CFStringEncoding kWideStringEncoding = kCFStringEncodingUTF32BE;
#elif defined(__LITTLE_ENDIAN__)
static const CFStringEncoding kWideStringEncoding = kCFStringEncodingUTF32LE;
#endif

template<typename StringType>
static StringType CFStringToSTLStringWithEncodingT(CFStringRef cfstring,
                                                   CFStringEncoding encoding) {
    CFIndex length = CFStringGetLength(cfstring);
    if (length == 0)
        return StringType();
    
    CFRange whole_string = CFRangeMake(0, length);
    CFIndex out_size;
    CFIndex converted = CFStringGetBytes(cfstring,
                                         whole_string,
                                         encoding,
                                         0,      // lossByte
                                         false,  // isExternalRepresentation
                                         NULL,   // buffer
                                         0,      // maxBufLen
                                         &out_size);
    if (converted == 0 || out_size == 0)
        return StringType();
    
    typename StringType::size_type elements =
    out_size * sizeof(UInt8) / sizeof(typename StringType::value_type) + 1;
    
    std::vector<typename StringType::value_type> out_buffer(elements);
    converted = CFStringGetBytes(cfstring,
                                 whole_string,
                                 encoding,
                                 0,      // lossByte
                                 false,  // isExternalRepresentation
                                 reinterpret_cast<UInt8*>(&out_buffer[0]),
                                 out_size,
                                 NULL);  // usedBufLen
    if (converted == 0)
        return StringType();
    
    out_buffer[elements - 1] = '\0';
    return StringType(&out_buffer[0], elements - 1);
}

}

std::wstring SysCFStringRefToWide(CFStringRef ref) {
    return CFStringToSTLStringWithEncodingT<std::wstring>(ref,
                                                          kWideStringEncoding);
}
