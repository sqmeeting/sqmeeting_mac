//
//  SVCLayoutManager.h
//  TestDemo
//
//  Created by 徐亚飞 on 2020/6/8.
//  Copyright © 2020 徐亚飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define REMOTE_PEOPLE_VIDEO_NUMBER 5

typedef enum _SVCLayoutModeType
{
    SVC_LAYOUT_MODE_1X1,
    SVC_LAYOUT_MODE_1X2,
    SVC_LAYOUT_MODE_1X3,
    SVC_LAYOUT_MODE_1X4,
    SVC_LAYOUT_MODE_1X5,
    SVC_LAYOUT_MODE_NUMBER
}SVCLayoutModeType;

typedef struct _SVCLayoutDetail
{
    int videoViewNum;
    BOOL isSymmetical;
    float videoViewDescription[REMOTE_PEOPLE_VIDEO_NUMBER+2][4];  // +2 means adding local and content view
}SVCLayoutDetail;

@protocol SVCLayoutDelegate

@optional
- (void)refreshLayoutMode:(SVCLayoutModeType)mode Views:(NSMutableArray*)viewArray;
@end

@interface SVCLayoutManager : NSObject

+ (SVCLayoutManager *)getInstance;

@property (nonatomic, copy) NSMutableArray *svcVideoList;
@property (nonatomic, assign) SVCLayoutModeType svcLayoutMode;
@property (nonatomic, weak) id<SVCLayoutDelegate> delegate;

-(void)svcRefreshLayoutList:(NSMutableArray *)videoLayoutInfo;

@end

NS_ASSUME_NONNULL_END
