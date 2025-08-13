//
//  AppDelegate.h
//  TestBCDramaLib
//
//  Created by hanxiaoyu on 2025/8/13.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

