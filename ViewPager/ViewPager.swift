//
//  ViewPager.swift
//  ViewPager
//
//  Created by Septiyan Andika on 6/26/16.
//  Copyright © 2016 sailabs. All rights reserved.
//

import UIKit

@objc public protocol  ViewPagerDataSource {
    func numberOfItems(viewPager:ViewPager) -> Int
    func viewAtIndex(viewPager:ViewPager, index:Int, view:UIView?) -> UIView
    optional func didSelectedItem(index:Int)
    
}

public class ViewPager: UIView {
    
    var pageControl:UIPageControl = UIPageControl()
    var scrollView:UIScrollView = UIScrollView()
    var currentPosition:Int = 0
    
    var dataSource:ViewPagerDataSource? = nil {
        didSet {
            reloadData()
        }
    }
    
    var numberOfItems:Int = 0
    var itemViews:Dictionary<Int, UIView> = [:]
    
    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        setupScroolView();
        setupPageControl();
        reloadData()
    }
    
    func setupScroolView() {
        scrollView.pagingEnabled = true;
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self;
        let topContraints = NSLayoutConstraint(item: scrollView, attribute:
            .Top, relatedBy: .Equal, toItem: self,
                  attribute: NSLayoutAttribute.Top, multiplier: 1.0,
                  constant: 0)
        
        let bottomContraints = NSLayoutConstraint(item: scrollView, attribute:
            .Bottom, relatedBy: .Equal, toItem: self,
                     attribute: NSLayoutAttribute.Bottom, multiplier: 1.0,
                     constant: 0)
        
        let leftContraints = NSLayoutConstraint(item: scrollView, attribute:
            .LeadingMargin, relatedBy: .Equal, toItem: self,
                            attribute: .LeadingMargin, multiplier: 1.0,
                            constant: 0)
        
        let rightContraints = NSLayoutConstraint(item: scrollView, attribute:
            .TrailingMargin, relatedBy: .Equal, toItem: self,
                             attribute: .TrailingMargin, multiplier: 1.0,
                             constant: 0)
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([topContraints,rightContraints,leftContraints,bottomContraints])
    }
    
    func setupPageControl() {
        
        self.pageControl.numberOfPages = numberOfItems
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.greenColor()
        
        
        let heightContraints = NSLayoutConstraint(item: pageControl, attribute:
            .Height, relatedBy: .Equal, toItem: nil,
                     attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0,
                     constant: 25)
        
        let bottomContraints = NSLayoutConstraint(item: pageControl, attribute:
            .Bottom, relatedBy: .Equal, toItem: self,
                     attribute: NSLayoutAttribute.Bottom, multiplier: 1.0,
                     constant: 0)
        
        let leftContraints = NSLayoutConstraint(item: pageControl, attribute:
            .LeadingMargin, relatedBy: .Equal, toItem: self,
                            attribute: .LeadingMargin, multiplier: 1.0,
                            constant: 0)
        
        let rightContraints = NSLayoutConstraint(item: pageControl, attribute:
            .TrailingMargin, relatedBy: .Equal, toItem: self,
                             attribute: .TrailingMargin, multiplier: 1.0,
                             constant: 0)
        
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([heightContraints,rightContraints,leftContraints,bottomContraints])
    }
    
    
    func reloadData() {
        if(dataSource != nil){
            numberOfItems = (dataSource?.numberOfItems(self))!
        }
        self.pageControl.numberOfPages = numberOfItems
        
        itemViews.removeAll()
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width *  CGFloat(self.numberOfItems) , self.scrollView.frame.height)
            self.reloadViews(0)
        }
        
    }
    
    func loadViewAtIndex(index:Int){
        let view:UIView?
        if(dataSource != nil){
            view =  (dataSource?.viewAtIndex(self, index: index, view: itemViews[index]))!
        }else{
            view = UIView()
        }
        
        setFrameForView(view!, index: index);
        
        
        if(itemViews[index] == nil){
            itemViews[index] = view
            let tap = UITapGestureRecognizer(target: self, action:  #selector(self.handleTapSubView))
            tap.numberOfTapsRequired = 1
            itemViews[index]!.addGestureRecognizer(tap)
            
            scrollView.addSubview(itemViews[index]!)
        }else{
            itemViews[index] = view
        }
        
    }
    
    func handleTapSubView() {
        if(dataSource?.didSelectedItem != nil){
            dataSource?.didSelectedItem!(currentPosition)
        }
    }
    
    
    func reloadViews(index:Int){
        
        for i in (index-1)...(index+1) {
            if(i>=0 && i<numberOfItems){
                loadViewAtIndex(i);
            }
        }
        
        // print(scrollView.subviews.count)
    }
    
    func setFrameForView(view:UIView,index:Int){
        view.frame = CGRect(x: self.scrollView.frame.width*CGFloat(index), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height);
    }
    
    
}

extension ViewPager:UIScrollViewDelegate{
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        currentPosition = pageControl.currentPage
        reloadViews(Int(pageNumber));
    }
    
    
}

extension ViewPager{
    
    
    func animationNext(){
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ViewPager.moveToNextPage), userInfo: nil, repeats: true)
    }
    func moveToNextPage (){
        if(currentPosition <= numberOfItems && currentPosition > 0) {
            scrollToPage(currentPosition)
            currentPosition = currentPosition + 1
            if currentPosition > numberOfItems {
                currentPosition = 1
            }
        }
    }
    
    func scrollToPage(index:Int) {
        if(index <= numberOfItems && index > 0) {
            let zIndex = index - 1
            let iframe = CGRect(x: self.scrollView.frame.width*CGFloat(zIndex), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height);
            scrollView.setContentOffset(iframe.origin, animated: true)
            pageControl.currentPage = zIndex
            reloadViews(zIndex)
            currentPosition = index
        }
    }
    
}