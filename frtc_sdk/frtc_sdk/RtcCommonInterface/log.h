#pragma once

#include <rtc_log.h>

#define ENABLE_DEBUG_LOG 1

#if defined _WIN32
#define __FILENAME__ (strrchr(__FILE__, '\\') ? (strrchr(__FILE__, '\\') + 1):__FILE__)
#else
#define __FILENAME__ (strrchr(__FILE__, '/') ? (strrchr(__FILE__, '/') + 1):__FILE__)
#endif

#define InitLog(ctx)         RTC::InitLog(ctx)
#define LogPrint(level, fmt, ...) RTC::Log("FSDK", level, "[%s:%d] " fmt, __FILENAME__, __LINE__, ##__VA_ARGS__)

#define ErrorLog(fmt, ...)      LogPrint(RTC::kError, fmt, ##__VA_ARGS__)
#define WarnLog(fmt, ...)       LogPrint(RTC::kWarn, fmt, ##__VA_ARGS__)
#define InfoLog(fmt, ...)       LogPrint(RTC::kInfo, fmt, ##__VA_ARGS__)

#if ENABLE_DEBUG_LOG
#define DebugLog(fmt, ...)      LogPrint(RTC::kDebug, fmt, ##__VA_ARGS__)
#else
#define DebugLog(fmt, ...)
#endif
