//
//  UpdateCoreDataWithParseData.h
//  Connoisseur
//
//  Created by Eduardo Flores on 7/31/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

// Adding Delegation
@class UpdateCoreDataWithParseData;
@protocol UpdateCoreDataDelegate <NSObject>
-(void)updateComplete;
@end

@interface UpdateCoreDataWithParseData : NSObject

-(void)updateDataWithContext:(NSManagedObjectContext *)managedObjectContext
    fetchedResultsController:(NSFetchedResultsController *)resultsController
              lastObjectDate:(NSDate *)lastObjectDate;

@property (nonatomic, assign) id delegate;

@end
