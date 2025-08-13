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
    self.dramaWrapper = [[BCDramaLibWrapper alloc] init];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];

    CGFloat yOffset = 20.0;

    // Init SDK
    UIButton *initButton = [self createButtonWithTitle:@"Init SDK" action:@selector(initSDK)];
    initButton.frame = CGRectMake(20, yOffset, self.view.frame.size.width - 40, 40);
    [scrollView addSubview:initButton];
    yOffset += 50;

    // Show SDK
    UIButton *showSDKButton = [self createButtonWithTitle:@"Show SDK" action:@selector(showSDK)];
    showSDKButton.frame = CGRectMake(20, yOffset, self.view.frame.size.width - 40, 40);
    [scrollView addSubview:showSDKButton];
    yOffset += 50;

    // Show Collection Page
    UIButton *showCollectionButton = [self createButtonWithTitle:@"Show Collection Page" action:@selector(showCollectionPage)];
    showCollectionButton.frame = CGRectMake(20, yOffset, self.view.frame.size.width - 40, 40);
    [scrollView addSubview:showCollectionButton];
    yOffset += 50;

    // Show Album List Page
    UIButton *showAlbumListButton = [self createButtonWithTitle:@"Show Album List Page" action:@selector(showAlbumListPage)];
    showAlbumListButton.frame = CGRectMake(20, yOffset, self.view.frame.size.width - 40, 40);
    [scrollView addSubview:showAlbumListButton];
    yOffset += 50;

    // Show Recommend Page
    UIButton *showRecommendButton = [self createButtonWithTitle:@"Show Recommend Page" action:@selector(showRecommendPage)];
    showRecommendButton.frame = CGRectMake(20, yOffset, self.view.frame.size.width - 40, 40);
    [scrollView addSubview:showRecommendButton];
    yOffset += 50;

    // Jump to Video Play
    UIButton *jumpToPlayButton = [self createButtonWithTitle:@"Jump to Video Play" action:@selector(jumpToVideoPlay)];
    jumpToPlayButton.frame = CGRectMake(20, yOffset, self.view.frame.size.width - 40, 40);
    [scrollView addSubview:jumpToPlayButton];
    yOffset += 50;

    // Jump to More Detail List
    UIButton *jumpToMoreButton = [self createButtonWithTitle:@"Jump to More Detail" action:@selector(jumpToMoreDetail)];
    jumpToMoreButton.frame = CGRectMake(20, yOffset, self.view.frame.size.width - 40, 40);
    [scrollView addSubview:jumpToMoreButton];
    yOffset += 50;

    // Set Callbacks
    UIButton *setCallbacksButton = [self createButtonWithTitle:@"Set Callbacks" action:@selector(setCallbacks)];
    setCallbacksButton.frame = CGRectMake(20, yOffset, self.view.frame.size.width - 40, 40);
    [scrollView addSubview:setCallbacksButton];
    yOffset += 50;

    // Logout
    UIButton *logoutButton = [self createButtonWithTitle:@"Logout" action:@selector(logout)];
    logoutButton.frame = CGRectMake(20, yOffset, self.view.frame.size.width - 40, 40);
    [scrollView addSubview:logoutButton];
    yOffset += 50;

    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yOffset);
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    return button;
}

- (void)initSDK {
    [self.dramaWrapper initSDKWithAppId:@"your_app_id"
                            packageName:@"your_package_name"
                                 secret:@"your_secret"
                                 userId:@"your_user_id"];
    NSLog(@"Init SDK called");
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
    [self.dramaWrapper jumpToVideoMoreDetailListFrom:self menuId:1 menuName:@"Menu Name"];
}

- (void)setCallbacks {
    [self.dramaWrapper setVideoPlayCallBackOnStart:^(NSInteger videoId, NSInteger episode) {
        NSLog(@"Video play started for videoId: %ld, episode: %ld", (long)videoId, (long)episode);
    } onProgress:^(NSInteger videoId, NSInteger episode, NSInteger current, NSInteger total) {
        NSLog(@"Video progress: %ld/%ld", (long)current, (long)total);
    } onEnd:^(NSInteger videoId, NSInteger episode) {
        NSLog(@"Video ended for videoId: %ld, episode: %ld", (long)videoId, (long)episode);
    } onUnlock:^(NSInteger videoId, NSInteger episode) {
        NSLog(@"Video unlocked for videoId: %ld, episode: %ld", (long)videoId, (long)episode);
    } onReward:^(NSInteger videoId, NSInteger episode) {
        NSLog(@"Video reward for videoId: %ld, episode: %ld", (long)videoId, (long)episode);
    }];

    [self.dramaWrapper setPaymentCallbackOnPayment:^(NSString * _Nonnull json) {
        NSLog(@"Payment callback with json: %@", json);
    }];

    [self.dramaWrapper setPaymentOnPaySuccess:^{
        NSLog(@"Payment success");
    }];

    NSLog(@"Callbacks set");
}

- (void)logout {
    [self.dramaWrapper logout];
    NSLog(@"Logout called");
}

@end
