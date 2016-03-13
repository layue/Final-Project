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
            const char *sql_stmt = "create table if not exists vehicleAccelerometer (time text, ax float, ay float, az float, status text)";
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

- (BOOL) clearDB {
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
    if ([filemgr fileExistsAtPath: dbPath] == YES)
    {
        const char *dbpath = [dbPath UTF8String];
        if (sqlite3_open(dbpath, &db) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "delete from vehicleAccelerometer;";
            
            if (sqlite3_exec(db, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                NSLog(@"Failed to delete table");
                isSuccess = NO;
            }
            sqlite3_close(db);
            return isSuccess;
        }
        else {
            NSLog(@"Failed to open database");
            isSuccess = NO;
            return isSuccess;
        }
    } else {
        NSLog(@"Failed to delete nonexisting database");
        isSuccess = NO;
        return isSuccess;
    }
}

- (BOOL) saveData:(NSMutableArray *) buffer
{
    const char *dbpath = [dbPath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSMutableString *insertSQL = [NSMutableString stringWithFormat:@"insert into vehicleAccelerometer (time, ax, ay, az, status) values "];
//        (\"%@\",\"%@\", \"%@\", \"%@\")", time, ax, ay, az];
        
        for (id obj in buffer) {
            NSString *value = [NSString stringWithFormat:@"(\'%@\', %f, %f, %f, \'%@\'), ", obj[0], [obj[1] doubleValue], [obj[2] doubleValue], [obj[3] doubleValue], obj[4]];
            [insertSQL appendString:value];
        }
        [insertSQL replaceCharactersInRange:NSMakeRange([insertSQL length] - 2, 2) withString:@";"];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(db, insert_stmt,-1, &statement, NULL);

        int state = sqlite3_step(statement);
        if (state == SQLITE_DONE) {
            return YES;
        }
        else {
            return NO;
        }
//        sqlite3_reset(statement);
    }
    return NO;
}

@end
