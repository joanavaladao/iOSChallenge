//
//  Waiter.h
//  StaffManagement
//
//  Created by Derek Harasen on 2015-03-14.
//  Copyright (c) 2015 Derek Harasen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant;

@interface Waiter : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) NSSet *shifts;
@end


@interface Waiter (CoreDataGeneratedAccessors)

- (void)addShiftsObject:(NSManagedObject *)value;
- (void)removeShiftsObject:(NSManagedObject *)value;
- (void)addShifts:(NSSet *)values;
- (void)removeShifts:(NSSet *)values;

@end
