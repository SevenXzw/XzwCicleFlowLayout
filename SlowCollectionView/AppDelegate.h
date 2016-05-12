//
//  AppDelegate.h
//  SlowCollectionView
//
//  Created by Vilson on 16/5/11.
//  Copyright © 2016年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XzwTextViewController.h"
#define __OPEN__CATEGORY(category,origin,size) [[category alloc]initWithFrame:(CGRect){origin,size}]
#define __SET__OBJECT__UI(category,origin,size,backGroundColor,rootObject) \
                                       self.window = __OPEN__CATEGORY(category,origin,size);\
                                       self.window.backgroundColor = backGroundColor;\
                                       self.window.rootViewController = [rootObject new];\
                                       [self.window makeKeyAndVisible];
#define __SET__OBJECT__OPEN__OBJECT(category,origin,size,backGroundColor,rootObject) \
@try {__SET__OBJECT__UI(category,origin,size,backGroundColor, rootObject)} \
@catch (NSException *exception) {UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Cancel" message:[[NSString alloc] initWithFormat:@"%@",exception] delegate:self cancelButtonTitle:nil otherButtonTitles:@"PERMIT", nil];\
    [alert show];} @finally {NSLog(@"go to 'Hello World!'");}
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end

