#pragma once

#define TO_STR(arg)     #arg
#define TO_STRING(arg)  TO_STR(arg)

#define RTC_VER_MAJOR   3
#define RTC_VER_MINOR   4
#define RTC_VER_SUB     0
#define RTC_VER_SUB1    1

#define RTC_DLL_VERSION TO_STRING(RTC_VER_MAJOR) "." TO_STRING(RTC_VER_MINOR) "." TO_STRING(RTC_VER_SUB)
