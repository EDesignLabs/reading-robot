//
//  AlertScreenView.h
//  Broadcastr
//
//  Created by Ilya Lyashevsky on 11/21/11.
//  Copyright (c) 2011 FoundLanguage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertScreenView : UIView
{
    UILabel *messageLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *messageLabel;

@end
