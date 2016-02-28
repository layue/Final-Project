//
//  DBManager.h
//  BumpDetection
//
//  Created by 徐冰 on 22/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *dbPath;
}

+ (DBManager *) getSharedInstance;
- (BOOL) createDB;
- (BOOL) saveData:(NSMutableArray *) buffer;

@end
