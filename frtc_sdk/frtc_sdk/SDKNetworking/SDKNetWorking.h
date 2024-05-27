#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RequestCompletionHandler)(NSDictionary * requestInfomation);
typedef void (^RequestFailure)(NSError *error);

@interface SDKNetWorking : NSObject

+ (SDKNetWorking *)sharedSDKNetWorking;

- (void)sdkNetWorkingPOST:(NSString *)uri
                userToken:(NSString *)userToken
               parameters:(nullable NSDictionary *)parameters
 requestCompletionHandler:(RequestCompletionHandler)completionHandler
       requestPOSTFailure:(RequestFailure)failuer;

- (void)sdkNetWorkingGET:(NSString *)uri
               userToken:(NSString *)userToken
              parameters:(nullable NSDictionary *)parameters
requestCompletionHandler:(RequestCompletionHandler)completionHandler
      requestPOSTFailure:(RequestFailure)failuer;

- (void)sdkNetWorkingGET:(NSString *)uri
              parameters:(nullable NSDictionary *)parameters
requestCompletionHandler:(RequestCompletionHandler)completionHandler
      requestPOSTFailure:(RequestFailure)failuer;

- (void)sdkNetWorkingGET:(NSString *)uri
               userToken:(NSString *)userToken
        searchUserFilter:(NSString *)filter
              parameters:(nullable NSDictionary *)parameters
requestCompletionHandler:(RequestCompletionHandler)completionHandler
      requestPOSTFailure:(RequestFailure)failuer;

- (void)sdkNetWorkingPUT:(NSString *)uri
               userToken:(NSString *)userToken
              parameters:(nullable NSDictionary *)parameters
requestCompletionHandler:(RequestCompletionHandler)completionHandler
      requestPOSTFailure:(RequestFailure)failuer;

- (void)sdkNetWorkingDELETE:(NSString *)uri
                  userToken:(NSString *)userToken
                 parameters:(nullable NSDictionary *)parameters
   requestCompletionHandler:(RequestCompletionHandler)completionHandler
       requestDELETEFailure:(RequestFailure)failuer;

- (void)sdkNetWorkingDELETE:(NSString *)uri
                  userToken:(NSString *)userToken
                isCancelAll:(BOOL)isCancelAll
                 parameters:(nullable NSDictionary *)parameters
   requestCompletionHandler:(RequestCompletionHandler)completionHandler
       requestDELETEFailure:(RequestFailure)failuer;


@end

NS_ASSUME_NONNULL_END
