#pragma once

#include "rtc_definitions.h"

#if defined(_WINDLL)
#define RTC_API  __declspec(dllexport)
#else
#define RTC_API
#endif

namespace RTC
{

RTC_API void InitLog(void *log_context);
RTC_API void Log(const char *tag, LogLevel level, const char *fmt, ...);

}
