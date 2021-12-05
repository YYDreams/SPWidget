//
//  Config.swift
//  SwiftProject
//
//  Created by flowerflower on 2021/10/17.
//

import UIKit

// MARK: ------------------------- Const/Enum/Struct
public enum MaskType {
    case color
    case effect
}


public enum PopViewShowType {
    case top
    case left
    case bottom
    case right
    case center
}

// MARK: ------------------------- ShowAlertViewConfig
public class ShowAlertConfig {
    
    /// 背景蒙版 毛玻璃
    public var effectStyle = UIBlurEffect.Style.light
    
    /// 点击其他地方是否消失 默认true
    public var clickOtherHidden = true
    
    /// 默认蒙版类型
    public var maskType: MaskType = .color
    
    
    /// 弹出视图样式位置
    public var showAnimateType : PopViewShowType? = .center
    
    
    // ------------------------- 字体颜色
    ///alert背景颜色
    public var backgroundColor : UIColor = UIColor.black.withAlphaComponent(0.5)
    
    
    ///alert标题字体
    public var titleFont : UIFont = UIFont.systemFont(ofSize: 21)
    /// alert标题字体颜色
    public var titleColor : UIColor = UIColor.black
    
    ///alert信息字体
    public var messageFont : UIFont = UIFont.systemFont(ofSize: 14)
    
    /// alert信息字体颜色
    public var messageColor : UIColor = UIColor.black
    
    /// alert按钮字体颜色 （如果底部只有一个按钮的情况，只设置左边按钮即可）
    public var leftBtnTitleColor : UIColor = UIColor.black
    public var rightBtnTitleColor : UIColor = UIColor.black
    
    /// alert按钮背景颜色
    public var leftBtnBgColor : UIColor = UIColor.white
    public var rightBtnBgColor : UIColor = UIColor.white
    
    public var leftBtnBorderWidth : CGFloat = 0
    public var leftBtnBorderColor : UIColor = UIColor.white
    
    public var rightBtnBorderWidth : CGFloat = 0
    public var rightBtnBorderColor : UIColor = UIColor.white
    
    
    
    //  ------------------------- 常量
    
    /// 圆角
    public var cornerRadius:CGFloat = 0.0
    
    /// 指定某几个角为圆角  默认左上 右上
    public var corners:UIRectCorner = [.topLeft, .topRight]
    
    ///alert宽度
    public var maxWidth : CGFloat = UIScreen.main.bounds.size.width - 88.0
    
    ///alert最大高度
    public var maxHeight : CGFloat = 500
    
    /// title距离顶部的距离
    public var titleTopSpacing :CGFloat = 0.0
    
    ///message距离title之前的间距的距离
    public var messageTopSpacing : CGFloat = 0
    
    ///alert按钮高度
    public var buttonHeight : CGFloat = 40
    
    ///距离底部间距
    public var bottomSpacing : CGFloat = 0
    
    ///左边按钮间距
    public var  leftBtnSpacing : CGFloat = 0
    ///右边按钮间距
    public var  rightBtnSpacing : CGFloat = 0
    
    ///按钮圆角
    public var  buttonRadius : CGFloat = 0
    
    /// 按钮之间的间距（左边按钮与右边按钮）
    open var buttonSpacing: CGFloat = 0
    
    /// 执行动画时间
    public var animateDuration = 0.25
    
    ///动画是否弹性
    public var animateDamping = false
       
}

// MARK: ------------------------- ShowPopViewConfig
open class  ShowPopViewConfig {
    
    /// 背景蒙版 毛玻璃
    public var effectStyle = UIBlurEffect.Style.light
    
    /// 点击其他地方是否消失 默认true
    public var clickOtherHidden = true
    
    /// 默认蒙版类型
    public var maskType: MaskType = .color
    
    /// 弹出视图样式位置
    public var showAnimateType : PopViewShowType? = .center
    
    /// 背景颜色 默认蒙版
    public var backgroundColor : UIColor = UIColor.black.withAlphaComponent(0.5)
    
    /// 执行动画时间
    public var animateDuration = 0.25
    
    ///动画是否弹性
    public var animateDamping = false
    
    /// 圆角
    public var cornerRadius:CGFloat = 0.0
     
    /// 指定某几个角为圆角  
    public var corners:UIRectCorner = []
    
}

