//
//  Shift.h
//  StaffManagement
//
//  Created by Joana Valadão Bittencourt on 2018-04-14.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Waiter;

@interface Shift : NSManagedObject

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic, retain) Waiter *waiter;

@end
