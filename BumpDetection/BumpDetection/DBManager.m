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
                    [docsDir stringByAppendingPathComponent: @"BumpRecord.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: dbPath ] == NO)
    {
        const char *dbpath = [dbPath UTF8String];
        if (sqlite3_open(dbpath, &db) == SQLITE_OK)
        {
            char *errMsg;
//TODO: Change DB. Create
            const char *sql_stmt = "create table if not exists BumpRecord (time text, ax double, ay double, az double, latitude double, longitude double, travelDirection double, speed double, batteryLevel double, streetName text)";
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
              [docsDir stringByAppendingPathComponent: @"BumpRecord.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: dbPath] == YES)
    {
        const char *dbpath = [dbPath UTF8String];
        if (sqlite3_open(dbpath, &db) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "delete from BumpRecord;";
            
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

//TODO: Change DB. Insert
        NSMutableString *insertSQL = [NSMutableString stringWithFormat:@"insert into BumpRecord (time, ax, ay, az, latitude, longitude, travelDirection, speed, batteryLevel, streetName) values "];
        for (id obj in buffer) {
            NSString *value = [NSString stringWithFormat:@"(\'%@\', %@, %@, %@, %@, %@, %@, %@, %@, \'%@\'), ", obj[0], obj[1], obj[2], obj[3], obj[4], obj[5], obj[6], obj[7], obj[8], obj[9]];
            [insertSQL appendString:value];
        }
        [insertSQL deleteCharactersInRange:NSMakeRange([insertSQL length] - 2, 2)];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(db, insert_stmt, -1, &statement, NULL);

        if (sqlite3_step(statement) == SQLITE_DONE) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}

//accData structure: timestamp, accX, accY, accZ, lantitude, longitude, course, speed, battery level, street number and name
- (NSArray *) readDB: (NSString *) selectStatement {
    NSMutableArray *accDBData = [[NSMutableArray alloc] init];
    const char *dbpath = [dbPath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK) {
        const char *select_stmt = [selectStatement UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while(sqlite3_step(statement) == SQLITE_ROW) {
                double lan = sqlite3_column_double(statement, 0);
                double lon = sqlite3_column_double(statement, 1);
                char *name = (char *)sqlite3_column_text(statement, 2);
                [accDBData addObject:@[[NSNumber numberWithDouble:lan], [NSNumber numberWithDouble:lon], [NSString stringWithUTF8String:name]]];
            }
        } else {
            NSLog(@"Failed to read data from DB!");
        }
    } else {
        NSLog(@"Failed to open DB!");
    }
    
    return accDBData;
}

@end
