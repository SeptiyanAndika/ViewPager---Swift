# ViewPager---Swift
An easy to use view pager library for iOS in Swift

# Installation
Just add ViewPager.swift file to your project,  file are present inside ViewPager directory.

# Preview
![Preview ](https://raw.githubusercontent.com/SeptiyanAndika/ViewPager---Swift/master/screenshot/viewpager.gif)

# Setup
The Viewpager follows the Apple convention for data-driven views by providing  protocol interfaces ViewPagerDataSource . The ViewPagerDataSource protocol has the following required methods:

	func numberOfItems(viewPager:ViewPager) -> Int

Return the number of items (views) in the Viewpager.

	func viewAtIndex(viewPager:ViewPager, index:Int, view:UIView?) -> UIView

Return a view to be displayed at the specified index in the ViewPager. The `view` argument, where views that have previously been displayed in the ViewPager are passed back to the method to be recycled. If this argument is not nil, you can set its properties and return it instead of creating a new view instance, which will slightly improve performance.

# Example
ViewController:

	override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.dataSource = self;
        // Do any additional setup after loading the view, typically from a nib.
    }


extension ViewController :

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
    }
  



