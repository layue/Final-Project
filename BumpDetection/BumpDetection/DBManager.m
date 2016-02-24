//
//  DBManager.m
//  BumpDetection
//
//  Created by 徐冰 on 22/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *db = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+ (DBManager *) getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

- (BOOL) createDB {
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    dbPath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"vehicleAccelerometer.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: dbPath ] == NO)
    {
        const char *dbpath = [dbPath UTF8String];
        if (sqlite3_open(dbpath, &db) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "create table if not exists studentsDetail (time text, ax integer, ay interger, az integer)";
            if (sqlite3_exec(db, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(db);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) saveData:(NSString *) time aX:(NSString *)ax
       aY:(NSString *)ay aZ:(NSString *)az;
{
    const char *dbpath = [dbPath UTF8String];
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into vehicleAccelerometer (time, ax, ay, az) values (\"%@\",\"%@\", \"%@\", \"%@\")", time, ax, ay, az];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(db, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
        }
        else {
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

@end
