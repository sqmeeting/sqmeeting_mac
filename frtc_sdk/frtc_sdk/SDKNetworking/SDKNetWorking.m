#import "SDKNetWorking.h"
#import "AFNetworking.h"
#import "FrtcUUID.h"
#import "SDKUserDefault.h"

static SDKNetWorking *sharedSDKNetWorkingDefault = nil;

@interface SDKNetWorking()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation SDKNetWorking

+ (SDKNetWorking *)sharedSDKNetWorking {
    if (sharedSDKNetWorkingDefault == nil) {
        @synchronized(self) {
            if (sharedSDKNetWorkingDefault == nil) {
                sharedSDKNetWorkingDefault = [[SDKNetWorking alloc] init];
            }
        }
    }
    
    return sharedSDKNetWorkingDefault;
}

- (instancetype)init {
    if(self = [super init]) {
        [self setAFNetWorking];
    }
    
    return self;
}

- (void)sdkNetWorkingPOST:(NSString *)uri
                userToken:(NSString *)userToken
               parameters:(nullable NSDictionary *)parameters
 requestCompletionHandler:(RequestCompletionHandler)completionHandler
       requestPOSTFailure:(RequestFailure)failuer {
    NSString *urlString = [self generateRestfulUrlWithUri:uri userToken:userToken];
    
    [_httpSessionManager POST:urlString parameters:parameters headers:[self HEADER] progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:YES forKey:SKD_LOGIN_VALUE];
        completionHandler((NSDictionary *)responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:NO forKey:SKD_LOGIN_VALUE];
        failuer(error);
    }];
}

- (void)sdkNetWorkingGET:(NSString *)uri
               userToken:(NSString *)userToken
        searchUserFilter:(NSString *)filter
              parameters:(nullable NSDictionary *)parameters
requestCompletionHandler:(RequestCompletionHandler)completionHandler
      requestPOSTFailure:(RequestFailure)failuer {
    NSString *serverAddress = [[SDKUserDefault sharedSDKUserDefault] sdkObjectForKey:SKD_SERVER_ADDRESS];
    NSString *uuid = [[FrtcUUID sharedUUID] getAplicationUUID];
    
    NSString *restfulUrl;
    if([uri containsString:@"/api/v1/meeting_schedule"]) {
        restfulUrl = [NSString stringWithFormat:@"https://%@%@?client_id=%@&token=%@&page_num=1&page_size=50", serverAddress, uri, uuid, userToken];
    } else {
        restfulUrl = [NSString stringWithFormat:@"https://%@%@?client_id=%@&token=%@&page_num=1&page_size=50&filter=%@", serverAddress, uri, uuid, userToken, filter];
    }
    
    [_httpSessionManager GET:restfulUrl parameters:parameters headers:[self HEADER] progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"min");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler((NSDictionary *)responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failuer(error);
    }];
}

- (void)sdkNetWorkingGET:(NSString *)uri
               userToken:(NSString *)userToken
              parameters:(nullable NSDictionary *)parameters
requestCompletionHandler:(RequestCompletionHandler)completionHandler
      requestPOSTFailure:(RequestFailure)failuer {
    NSString *urlString = [self generateRestfulUrlWithUri:uri userToken:userToken];
    //urlString = @"https://39.101.193.125:5568/api/v1/user/info?client_id=d79b4a4a-4a9b-40b3-9a85-a69a9095860d&token=04000066-3623-432b-8435-f311fab35970";
    [_httpSessionManager GET:urlString parameters:parameters headers:[self HEADER] progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"get in progress");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler((NSDictionary *)responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failuer(error);
    }];
}

- (void)sdkNetWorkingGET:(NSString *)uri
              parameters:(nullable NSDictionary *)parameters
requestCompletionHandler:(RequestCompletionHandler)completionHandler
      requestPOSTFailure:(RequestFailure)failuer {
    [_httpSessionManager GET:uri parameters:parameters headers:[self HEADER] progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"get in progress");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler((NSDictionary *)responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failuer(error);
    }];
}

- (void)sdkNetWorkingPUT:(NSString *)uri
               userToken:(NSString *)userToken
              parameters:(nullable NSDictionary *)parameters
requestCompletionHandler:(RequestCompletionHandler)completionHandler
      requestPOSTFailure:(RequestFailure)failuer {
    NSString *urlString = [self generateRestfulUrlWithUri:uri userToken:userToken];
    
    [_httpSessionManager PUT:urlString parameters:parameters headers:[self HEADER] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler((NSDictionary *)responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failuer(error);
    }];
}

- (void)sdkNetWorkingDELETE:(NSString *)uri
                  userToken:(NSString *)userToken
                 parameters:(nullable NSDictionary *)parameters
   requestCompletionHandler:(RequestCompletionHandler)completionHandler
       requestDELETEFailure:(RequestFailure)failuer {
    NSString *urlString = [self generateRestfulUrlWithUri:uri userToken:userToken];

    _httpSessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    [_httpSessionManager DELETE:urlString parameters:parameters headers:[self HEADER] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler((NSDictionary *)responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failuer(error);
    }];
}

- (void)sdkNetWorkingDELETE:(NSString *)uri
                  userToken:(NSString *)userToken
                isCancelAll:(BOOL)isCancelAll
                 parameters:(nullable NSDictionary *)parameters
   requestCompletionHandler:(RequestCompletionHandler)completionHandler
       requestDELETEFailure:(RequestFailure)failuer {
    NSString *urlString = [self generateRestfulUrlWithUri:uri userToken:userToken];
    
    if(isCancelAll) {
        urlString = [NSString stringWithFormat:@"%@%@", urlString, @"&deleteGroup=true"];
    } else {
        urlString = [NSString stringWithFormat:@"%@%@", urlString, @"&deleteGroup=false"];
    }

    _httpSessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    [_httpSessionManager DELETE:urlString parameters:parameters headers:[self HEADER] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler((NSDictionary *)responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failuer(error);
    }];
}

#pragma mark --internal function--
- (NSString *)generateRestfulUrlWithUri:(NSString *)uri userToken:(NSString *)userToken {
    NSString *serverAddress;
    BOOL isUrlCall = [[SDKUserDefault sharedSDKUserDefault] sdkBoolObjectForKey:SKD_IF_URL_CALL];
    if(isUrlCall) {
        serverAddress = [[SDKUserDefault sharedSDKUserDefault] sdkObjectForKey:SKD_URL_VALUE];
    } else {
        serverAddress = [[SDKUserDefault sharedSDKUserDefault] sdkObjectForKey:SKD_SERVER_ADDRESS];
    }
    
    NSString *uuid = [[FrtcUUID sharedUUID] getAplicationUUID];
    NSString *restfulUrl;
    if([uri isEqualToString:@"/api/v1/user/sign_in"]) {
        restfulUrl = [NSString stringWithFormat:@"https://%@%@?client_id=%@", serverAddress, uri, uuid];
    } else if([uri isEqualToString:@"/api/v1/user/public/users"]) {
        restfulUrl = [NSString stringWithFormat:@"https://%@%@?client_id=%@&token=%@&page_num=1&page_size=50", serverAddress, uri, uuid, userToken];
    } else if([uri isEqualToString:@"/api/v1/user/public/users"]) {
        restfulUrl = [NSString stringWithFormat:@"https://%@%@?client_id=%@&token=%@&page_num=1&page_size=50", serverAddress, uri, uuid, userToken];
    }
    else if([userToken isEqualToString:@""] && [uri containsString:@"request_unmute"]) {
        restfulUrl = [NSString stringWithFormat:@"https://%@%@?client_id=%@",serverAddress, uri, uuid];
    } else if([userToken isEqualToString:@""]) {
        restfulUrl = [NSString stringWithFormat:@"https://%@%@/participant?client_id=%@",serverAddress, uri, uuid];
    } else {
        restfulUrl = [NSString stringWithFormat:@"https://%@%@?client_id=%@&token=%@",serverAddress, uri, uuid, userToken];
    }
    
    return restfulUrl;
}

- (void)setAFNetWorking {
    _httpSessionManager = [AFHTTPSessionManager manager];
    _httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _httpSessionManager.requestSerializer=[AFJSONRequestSerializer serializer];
    _httpSessionManager.requestSerializer.timeoutInterval = 10.f;
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:_httpSessionManager.responseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/plain"];
    _httpSessionManager.responseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;

    /*
     need skip certificate verify
     */
    _httpSessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _httpSessionManager.securityPolicy.allowInvalidCertificates = YES;
    [_httpSessionManager.securityPolicy setValidatesDomainName:NO];
}

#pragma mark --HTTP HEADER--
- (NSDictionary *)HEADER {
    return @{@"User-Agent":@"FrtcMeeting/3.3.0 mac"};
}

@end
