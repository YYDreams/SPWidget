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


// MARK: ------------------------- ShowPopView
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

// MARK: ------------------------- AlertView

extension Show{
    
    
    ///适配器回调,用于给适配器参数赋值
    public typealias ConfigAlert = ((_ config : ShowAlertConfig) -> Void)
    
    /// 默认样式Alert 底部单个按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 信息
    ///   - bottomBtnTitle:底部按钮的标题
    ///   - bottomBtnBlock: 底部按钮标题
    public class func showAlert(title: String? = nil,
                                message: String?  = nil,
                                bottomBtnTitle: String? = nil,
                                bottomBtnBlock: CallBack? = nil) {
        
//        showCustomAlert(title: title, message: message, bottomBtnTitle: bottomBtnTitle, bottomBtnBlock: bottomBtnBlock) { config in
//            config.maxHeight = 180
//            config.titleFont = UIFont.boldSystemFont(ofSize: 16)
//            config.messageFont = UIFont.systemFont(ofSize: 14)
//            config.messageColor = UIColor("#666666")
//        }
        
    }
    
    /// 自定义Alert
    /// - Parameters:
    ///   - title: 标题
    ///   - attributedTitle: 富文本标题
    ///   - titleImage: 顶图
    ///   - message: 信息
    ///   - attributedMessage: 富文本信息
    ///   - leftBtnTitle: 左侧按钮标题
    ///   - leftBtnAttributedTitle: 富文本左侧按钮标题
    ///   - rightBtnTitle: 右侧按钮标题
    ///   - rightBtnAttributedTitle: 富文本右侧按钮标题
    ///   - leftBlock:  左侧按钮回调
    ///   - rightBlock: 右侧按钮回调
    ///   - config: Alert适配器，不传为默认样式
    public class func showCustomAlert(title: String? = nil,
                                      attributedTitle : NSAttributedString? = nil,
                                      message: String?  = nil,
                                      attributedMessage : NSAttributedString? = nil,
                                      leftBtnTitle: String? = nil,
                                      leftBtnAttributedTitle: NSAttributedString? = nil,
                                      rightBtnTitle: String? = nil,
                                      rightBtnAttributedTitle: NSAttributedString? = nil,
                                      leftBlock: LeftCallBack? = nil,
                                      rightBlock: RightCallback? = nil,
                                      config : ConfigAlert? = nil) {
        hiddenAlert()
        
        let model = ShowAlertConfig()
        model.titleTopSpacing = 24
        model.bottomSpacing = 24
        model.leftBtnSpacing =  16
        model.rightBtnSpacing =  16
        model.messageFont = UIFont.systemFont(ofSize: 16)
        model.buttonSpacing  =  16
        model.buttonRadius = 20
        model.messageTopSpacing = 10
        model.buttonFont = UIFont.boldSystemFont(ofSize: 14)
        model.leftBtnBgColor = UIColor.white
        model.rightBtnBgColor = UIColor.red
        model.leftBtnBorderWidth = 0.5
        model.leftBtnBorderColor = UIColor.gray
        model.leftBtnTitleColor = UIColor.black
        model.rightBtnTitleColor = UIColor.white
        
        config?(model)


        let alertView = SPAlertView.init(title: title,
                                       attributedTitle: attributedTitle,
                                       message: message,
                                       attributedMessage: attributedMessage,
                                       leftBtnTitle: leftBtnTitle,
                                       leftBtnAttributedTitle: leftBtnAttributedTitle,
                                       rightBtnTitle: rightBtnTitle,
                                       rightBtnAttributedTitle: rightBtnAttributedTitle,
                                       config: model)
        alertView.leftBlock = leftBlock
        alertView.rightBlock = rightBlock
        alertView.dismissBlock = {
            hiddenAlert()
        }
        getWindow().addSubview(alertView)
        alertView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    
    /// 手动隐藏Alert
    public class func hiddenAlert() {
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: SPAlertView.self){
                
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = 0
                }) { (_) in
                    view.removeFromSuperview()
                }
            }
        }
    }

    
}
