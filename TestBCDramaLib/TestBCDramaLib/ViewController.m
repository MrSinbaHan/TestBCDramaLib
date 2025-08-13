//
//  ViewController.m
//  TestBCDramaLib
//
//  Created by hanxiaoyu on 2025/8/13.
//

#import "ViewController.h"
#import "TestBCDramaLib-Swift.h"

@interface ViewController ()
@property (nonatomic, strong) BCDramaLibWrapper *dramaWrapper;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BCDramaLib Demo";
    self.view.backgroundColor = [UIColor whiteColor];

    self.dramaWrapper = [[BCDramaLibWrapper alloc] init];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scrollView];

    // --- Create Buttons ---
    NSMutableArray *buttons = [NSMutableArray array];

    [buttons addObject:[self createButtonWithTitle:@"1. Init SDK" action:@selector(initSDK)]];
    [buttons addObject:[self createButtonWithTitle:@"2. Set All Callbacks" action:@selector(setAllCallbacks)]];
    [buttons addObject:[self createButtonWithTitle:@"3. Show SDK (Default)" action:@selector(showSDK)]];
    [buttons addObject:[self createButtonWithTitle:@"4. Show Collection Page" action:@selector(showCollectionPage)]];
    [buttons addObject:[self createButtonWithTitle:@"5. Show Album List Page" action:@selector(showAlbumListPage)]];
    [buttons addObject:[self createButtonWithTitle:@"6. Show Recommend Page" action:@selector(showRecommendPage)]];
    [buttons addObject:[self createButtonWithTitle:@"7. Jump to Video Play (ID:1, Ep:1)" action:@selector(jumpToVideoPlay)]];
    [buttons addObject:[self createButtonWithTitle:@"8. Jump to More Detail (ID:1)" action:@selector(jumpToMoreDetail)]];
    [buttons addObject:[self createButtonWithTitle:@"9. Get eCPM" action:@selector(getECPM)]];
    [buttons addObject:[self createButtonWithTitle:@"10. Logout" action:@selector(logout)]];

    // --- Layout Buttons ---
    CGFloat yOffset = 20.0;
    CGFloat xPadding = 20.0;
    CGFloat buttonHeight = 40.0;
    CGFloat buttonSpacing = 15.0;
    CGFloat width = self.view.frame.size.width - (2 * xPadding);

    for (UIButton *button in buttons) {
        button.frame = CGRectMake(xPadding, yOffset, width, buttonHeight);
        [scrollView addSubview:button];
        yOffset += buttonHeight + buttonSpacing;
    }

    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yOffset);
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 8;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    return button;
}

#pragma mark - Actions

- (void)initSDK {
    // Please replace with your actual credentials
    [self.dramaWrapper initSDKWithAppId:@"your_app_id"
                            packageName:@"your_package_name"
                                 secret:@"your_secret"
                                 userId:@"your_user_id"];
    NSLog(@"[DEMO] Init SDK called");
}

- (void)showSDK {
    [self.dramaWrapper showSDKFrom:self pageType:BCTabPageTypeWrapperCollection];
}

- (void)showCollectionPage {
    [self.dramaWrapper showCollectionPageFrom:self];
}

- (void)showAlbumListPage {
    [self.dramaWrapper showAlbumListPageFrom:self];
}

- (void)showRecommendPage {
    [self.dramaWrapper showRecommendPageFrom:self];
}

- (void)jumpToVideoPlay {
    [self.dramaWrapper jumpToVideoPlayControllerFrom:self videoId:1 lastEpisodeNo:1];
}

- (void)jumpToMoreDetail {
    [self.dramaWrapper jumpToVideoMoreDetailListFrom:self menuId:1 menuName:@"Example Menu"];
}

- (void)getECPM {
    [self.dramaWrapper getECPMWith:BCAdPlatformTypeWrapperUnion adType:BCAdTypeWrapperReward complete:^(NSInteger i, NSString * s, NSInteger adT) {
        NSLog(@"[CALLBACK] Get ECPM: i=%ld, s=%@, adT=%ld", (long)i, s, (long)adT);
    }];
    NSLog(@"[DEMO] Get ECPM called");
}

- (void)setAllCallbacks {
    // Video Playback Callbacks
    [self.dramaWrapper setVideoPlayCallBackOnStart:^(NSDictionary * _Nonnull data) {
        NSLog(@"[CALLBACK] Video play started: %@", data);
    } onProgress:^(NSInteger videoId, NSInteger episode, NSInteger current, NSInteger total) {
        NSLog(@"[CALLBACK] Video progress: VideoID=%ld, Episode=%ld, Progress=%ld/%ld", (long)videoId, (long)episode, (long)current, (long)total);
    } onEnd:^(NSDictionary * _Nonnull data) {
        NSLog(@"[CALLBACK] Video ended: %@", data);
    } onUnlock:^(NSDictionary * _Nonnull data) {
        NSLog(@"[CALLBACK] Video unlocked: %@", data);
    } onReward:^(NSDictionary * _Nonnull data) {
        NSLog(@"[CALLBACK] Video reward: %@", data);
    }];

    // Payment Callbacks
    [self.dramaWrapper setPaymentCallbackOnPayment:^(NSDictionary * _Nonnull data) {
        NSLog(@"[CALLBACK] Payment callback with data: %@", data);
    }];

    [self.dramaWrapper setPaymentOnPaySuccess:^(NSDictionary * _Nonnull data) {
        NSLog(@"[CALLBACK] Payment success with data: %@", data);
    }];

    [self.dramaWrapper paymentResultVerifyOnPayVerify:^(NSInteger data) {
        NSLog(@"[CALLBACK] Payment result verify: %ld", (long)data);
    }];

    // Ad Callbacks
    [self.dramaWrapper loadVideoAdCallbackOnLoaded:^(NSInteger adType, NSString * _Nullable s1, NSString * _Nullable s2, NSString * _Nullable s3) {
        NSLog(@"[CALLBACK] Ad loaded. Type: %ld, s1: %@, s2: %@, s3: %@", (long)adType, s1, s2, s3);
    } onClicked:^(NSInteger adType) {
        NSLog(@"[CALLBACK] Ad clicked. Type: %ld", (long)adType);
    } onEffective:^(NSInteger adType, NSInteger val) {
        NSLog(@"[CALLBACK] Ad effective. Type: %ld, val: %ld", (long)adType, (long)val);
    } onClosed:^(NSInteger adType) {
        NSLog(@"[CALLBACK] Ad closed. Type: %ld", (long)adType);
    } onFailed:^(NSInteger adType, NSError * _Nonnull error) {
        NSLog(@"[CALLBACK] Ad failed. Type: %ld, Error: %@", (long)adType, error);
    }];

    // Custom Ad Callbacks
    [self.dramaWrapper setCustomAdvCallbackOnInitAd:^(NSString * _Nonnull s) {
        NSLog(@"[CALLBACK] Custom Ad Init: %@", s);
    } rewardAd:^(NSString * _Nonnull s1, NSString * _Nonnull s2, NSString * _Nonnull s3) {
        NSLog(@"[CALLBACK] Custom Reward Ad: s1=%@, s2=%@, s3=%@", s1, s2, s3);
    } nativeExpressAd:^(NSString * _Nonnull s, double d1, double d2) {
        NSLog(@"[CALLBACK] Custom Native Express Ad: s=%@, d1=%f, d2=%f", s, d1, d2);
    } bannerAd:^(NSString * _Nonnull s) {
        NSLog(@"[CALLBACK] Custom Banner Ad: %@", s);
    }];

    // Other Callbacks
    [self.dramaWrapper loadNativeExpressRenderOnRender:^(NSInteger adType, BOOL success) {
        NSLog(@"[CALLBACK] Native Express Render. Type: %ld, Success: %d", (long)adType, success);
    }];

    NSLog(@"[DEMO] All callbacks have been set.");
}

- (void)logout {
    [self.dramaWrapper logout];
    NSLog(@"[DEMO] Logout called");
}

@end
