//
//  ViewController.m
//  StaffManagement
//
//  Created by Derek Harasen on 2015-03-14.
//  Copyright (c) 2015 Derek Harasen. All rights reserved.
//

#import "ViewController.h"
#import "Restaurant.h"
#import "RestaurantManager.h"
#import "Waiter.h"
//#import "Shift.h"

static NSString * const kCellIdentifier = @"CellIdentifier";

@interface ViewController ()
@property IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *waiters;
@property (nonatomic, retain) Restaurant *restaurant;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    self.restaurant = [[RestaurantManager sharedManager]currentRestaurant];
    self.waiters = [self.restaurant.staff sortedArrayUsingDescriptors:@[sortByName]];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView Data Source

@end
