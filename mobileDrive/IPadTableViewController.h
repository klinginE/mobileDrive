//
//  IPadTableViewController.h
//  mobileDrive
//
//  Created by Jesse Scott Pitel on 3/7/14.
//  Copyright (c) 2014 Data Dryvers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobileDriveAppDelegate.h"

#define LARGE_FONT_SIZE 30.0
#define MEDIAN_FONT_SIZE 25.0
#define SMALL_FONT_SIZE 20.0
#define CELL_HEIGHT (LARGE_FONT_SIZE + SMALL_FONT_SIZE + 10.0)
#define NUM_ALERTS 5
#define PATH_VIEW_HEIGHT 70

@interface IPadTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

typedef enum {HELP_BUTTON_TAG, ADD_DIR_BUTTON_TAG, BACK_BUTTON_TAG, MOVE_BUTTON_TAG, RENAME_BUTTON_TAG, DELETE_BUTTON_TAG, CANCEL_BUTTON_TAG} buttonTag;
typedef enum {ADD_ALERT_TAG=512, DELETE_ALERT_TAG, MOVE_ALERT_TAG, RENAME_ALERT_TAG, CONFIRM_ALERT_TAG, NONE} alertTag;

typedef struct {

    char *currentDir;
    char *currentPath;
    int depth;

}State;

-(id)initWithPath:(NSString *)currentPath target:(MobileDriveAppDelegate *)respond switchAction:(SEL)action forEvents:(UIControlEvents)events;
-(void)buttonPressed:(id)sendr;
-(UIBarButtonItem *)makeButtonWithTitle:(NSString *)title
                                    Tag:(NSInteger)tag
                                 Target:(id)target
                                 Action:(SEL)action;
-(char *)nsStringToCString:(NSString *)str;
-(void)initState:(State *)state WithPath:(NSString *)path;
-(void)freeState:(State)state;

@end