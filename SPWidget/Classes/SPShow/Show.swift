//
//  Show.swift
//  SwiftProject
//
//  Created by flowerflower on 2021/10/17.
//

import UIKit


public class Show {
    
    public typealias CallBack = () -> Void
    
    private static var showPopCallBack : CallBack?
    private static var hidePopCallBack : CallBack?

    
    
    
    private class func getWindow() -> UIWindow {
        var window = UIApplication.shared.keyWindow
        //是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level.normal{
                    window = windowTemp
                    break
                }
            }
        }
        return window!
    }
    
    
    
    /// 手动收起popview
    /// - Parameter complete: 完成回调
    public class func hidenPopView(_ complete : (() -> Void)? = nil ) {
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: PopView.self){
                let popView : PopView = view as! PopView
                popView.hideAnimate {
                    UIView.animate(withDuration: 0.1, animations: {
                        view.alpha = 0
                    }) { (_) in
                        complete?()
                        view.removeFromSuperview()
                        hidePopCallBack?()
                    }
                }
            }
        }
    }
    
}

extension Show{
    
    public typealias  ConfigPop = ((_ config: ShowPopViewConfig) -> Void)
    
    public class func showPopView(contentView: UIView,
                                  config: ConfigPop? = nil,
                                  showClosure: CallBack? = nil,
                                  hideClosure: CallBack? = nil){
        
        getWindow().subviews.forEach { view in
            if view.isKind(of: PopView.self){
                view.removeFromSuperview()
            }
            
            let popConfig = ShowPopViewConfig()
            config?(popConfig)
            
            let popView = PopView(contentView: contentView, config: popConfig){
                hidenPopView()
            }
         
            
            getWindow().addSubview(popView)
            popView.showAnimate()
            showPopCallBack?()
        }
    }
    
}
