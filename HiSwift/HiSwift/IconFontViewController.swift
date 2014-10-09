//
//  IconFontController.swift
//  LVHelloToIOS
//
//  Created by Levin Wong on 9/30/14.
//  Copyright (c) 2014 Levin Wong. All rights reserved.
//

import UIKit

class IconFontViewController: UIViewController {
    @IBOutlet weak var sliderFlat: UISlider!
    
    @IBOutlet weak var sliderSize: UISlider!
    @IBOutlet weak var sliderColor: UISlider!
    @IBOutlet weak var stageIcon: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stageIcon.font = UIFont(name:"fontello",size:130)
        stageIcon.text = NSString.stringWithUTF8String("\u{e801}")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func morphChanged(sender: AnyObject) {
        stageIcon.shadowColor = UIColor.grayColor()
        stageIcon.shadowOffset = CGSizeMake(1,CGFloat(sliderFlat.value))
    }
    @IBAction func colorChanged(sender: AnyObject) {
        
        var val = sliderColor.value
        
        
        if (val == 0.0) {
            stageIcon.textColor = UIColor.blackColor()
        }
        else {
            //stageIcon.textColor = [UIColor colorWithHue: value saturation: 0.8 brightness: 0.9 alpha: 1.0];
            stageIcon.textColor = UIColor(hue: CGFloat(val), saturation: CGFloat(0.8), brightness: CGFloat(0.9), alpha: CGFloat(1.0))
        }
    }
    @IBAction func sizeChanged(sender: AnyObject) {
        var size = sliderSize.value
        stageIcon.font = UIFont(name:"fontello",size:CGFloat(size) )
    }
    
}