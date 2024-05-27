//
//  SVCVideoInfo.h
//  TestDemo
//
//  Created by 徐亚飞 on 2020/6/8.
//  Copyright © 2020 徐亚飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    VIDEO_TYPE_LOCAL,
    VIDEO_TYPE_REMOTE,
    VIDEO_TYPE_CONTENT,
    VIDEO_TYPE_INVALID
} VideoType;

@interface SVCVideoInfo : NSObject

@property (nonatomic, copy) NSString *dataSourceID;
@property (nonatomic, copy) NSString *strDisplayName;

@property (nonatomic)  int resolution_width;
@property (nonatomic)  int resolution_height;

@property (nonatomic) VideoType eVideoType;

@property (nonatomic, assign, getter = isRemoved) BOOL removed;

@end

NS_ASSUME_NONNULL_END
