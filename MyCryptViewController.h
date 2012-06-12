//
//  MyCryptViewController.h
//  MyCrypt
//
//  Created by Nagoor.KaniS on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <UIKit/UIKit.h>

@interface MyCryptViewController : UIViewController {
    
    IBOutlet UIButton * btnEncrypt;
    IBOutlet UIButton * btnDecrypt;
    
}

-(IBAction)encryptButton;
-(IBAction)decryptButton;


@end
