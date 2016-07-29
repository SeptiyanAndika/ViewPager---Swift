//
//  ViewController.swift
//  SlideView
//
//  Created by Septiyan Andika on 6/26/16.
//  Copyright © 2016 sailabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var viewPager: ViewPager!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.dataSource = self;
        // Do any additional setup after loading the view, typically from a nib.
        viewPager.animationNext()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewPager.scrollToPage(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController:ViewPagerDataSource{
    func numberOfItems(viewPager:ViewPager) -> Int {
        return 5;
    }
    
    func viewAtIndex(viewPager:ViewPager, index:Int, view:UIView?) -> UIView {
        var newView = view;
        var label:UILabel?
        if(newView == nil){
            newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:  self.view.frame.height))
             newView!.backgroundColor = .randomColor()
            
            label = UILabel(frame: newView!.bounds)
            label!.tag = 1
            label!.autoresizingMask =  [.FlexibleWidth, .FlexibleHeight]
            label!.textAlignment = .Center
            label!.font =  label!.font.fontWithSize(28)
            newView?.addSubview(label!)
        }else{
          label = newView?.viewWithTag(1) as? UILabel
        }
       
        label?.text = "Page View Pager  \(index+1)"
        
        return newView!
    }
    
    func didSelectedItem(index: Int) {
        print("select index \(index)")
    }
   
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}


extension UIColor {
    static func randomColor() -> UIColor {
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
