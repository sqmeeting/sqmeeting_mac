# SQMeeting MacOS客户端

# 系统要求

## 操作系统
MacOS 10.15以上

## 系统平台

SQMeeting MacOS同时支持arm64和x86_64芯片

# 编译生成和运行

## 编译工具
下载安装当前系统支持的最新版本的Xcode

## 生成
如果是arm64平台，双击SQMeeting-arm64.xcworkspace，如果是X86_64平台，双击SQMeeting.xcworkspace。直接进行编译即可。

## 运行
在xcworkspace编译运行成功之后，即可弹出SQMeeting，或者可以在/SQMeeting/Release目录下，直接双击运行SQMeeting。如果MacOS系统版本低于13.0时，分享桌面或者app的同时需要共享音频时,需要安装SQMeeting提供的虚拟音频插件。进入FrtcVirtualDevice目录，双击FrtcMeetingVirtualDevice.pkg即可。如果系统版本在13.0及之上，则无需此操作。

# License
本项目基于 [Apache License, Version 2.0](./LICENSE) 开源，请在开源协议约束范围内使用源代码。  
本项目代码仅用于学习和研究使用。 任何使用本代码产生的后果，我们不承担任何法律责任。  
请联系我们获取商业支持.


