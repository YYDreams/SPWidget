//
//  PopView.swift
//  SwiftProject
//
//  Created by flowerflower on 2021/10/17.
//

import UIKit
import SnapKit

public class PopView: UIView {
    
    // MARK: ------------------------- Propertys
    private var popViewConfig : ShowPopViewConfig
    

    private var bgControl: UIControl?
    
    private var contentView: UIView?
    
    typealias HiddenPop = () -> Void
    private var hiddenPop : HiddenPop?
    
    private var contentSize = CGSize.zero
    
    // MARK: ------------------------- CycLife
    init(contentView: UIView,
         config : ShowPopViewConfig,
         hidenHandle : HiddenPop? = nil) {
        
        popViewConfig = config
        
        super.init(frame: UIScreen.main.bounds)
        
        self.contentView = contentView
        contentSize = contentView.bounds.size
        hiddenPop = hidenHandle
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: ------------------------- setupSubViews
    func setupSubViews(){
        
        /// 毛玻璃
        let effectView:UIVisualEffectView = {
            let effectView = UIVisualEffectView(effect: UIBlurEffect(style: popViewConfig.effectStyle))
            addSubview(effectView)
            effectView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            return effectView
        }()
        
        ///
          bgControl = {
            let backCtl = UIControl()
            backCtl.addTarget(self, action: #selector(backClick), for: .touchUpInside)
            addSubview(backCtl)
            backCtl.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            return backCtl
        }()
          
        
        addSubview(contentView ?? UIView())
        
        switch popViewConfig.maskType {
        case .effect:
            effectView.isHidden = false
            backgroundColor = .clear
        default:
            effectView.isHidden = true
            backgroundColor = popViewConfig.backgroundColor
        }
        
        switch popViewConfig.showAnimateType {
        case .top:
            contentView?.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top).offset( -contentSize.height)
                make.centerX.equalToSuperview()
                make.size.equalTo(contentSize)
            }
        case .left:
            contentView?.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.left).offset( -contentSize.width)
                make.centerY.equalToSuperview()
                make.size.equalTo(contentSize)
            }
        case .bottom:
            contentView?.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(contentSize.height)
                make.centerX.equalToSuperview()
                make.size.equalTo(contentSize)
            }
        case .right:
            contentView?.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(contentSize.width)
                make.centerY.equalToSuperview()
                make.size.equalTo(contentSize)
            }
        case .center:
            contentView?.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(contentSize)
            }
            contentView?.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        default:
            break
        }
        layoutIfNeeded()
    }
    
    // MARK: ------------------------- Events
    @objc func backClick(){
        if popViewConfig.clickOtherHidden {
            hiddenPop?()
        }
    }
    
    // MARK: ------------------------- Methods
    func showAnimate(){
        
        if popViewConfig.cornerRadius > 0 {
            contentView?.roundCorners(popViewConfig.corners, radius: popViewConfig.cornerRadius)
        }
        
        switch popViewConfig.showAnimateType {
        case .top:
            contentView?.snp.updateConstraints { (make) in
                make.top.equalToSuperview()
            }
        case .left:
            contentView?.snp.updateConstraints { (make) in
                make.left.equalToSuperview()
            }
        case .bottom:
            contentView?.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview()
            }
        case .right:
            contentView?.snp.updateConstraints { (make) in
                make.right.equalToSuperview()
            }
        case .center:
            UIView.animate(withDuration: popViewConfig.animateDuration) {
                self.contentView?.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }
            return
        default:
            break
        }
        
        if popViewConfig.animateDamping {
            UIView.animate(withDuration: popViewConfig.animateDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: {
                self.layoutIfNeeded()
            }) { (finished) in
                
            }
        }else{
            UIView.animate(withDuration: popViewConfig.animateDuration) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func hideAnimate(_ block : HiddenPop?){
        
        switch popViewConfig.showAnimateType {
        case .top:
            contentView?.snp.updateConstraints { (make) in
                make.top.equalTo(self.snp.top).offset( -contentSize.height)
            }
            
        case .left:
            contentView?.snp.updateConstraints { (make) in
                make.left.equalTo(self.snp.left).offset( -contentSize.width)
            }
        case .bottom:
            contentView?.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(contentSize.height)
            }
        case .right:
            contentView?.snp.updateConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(contentSize.width)
            }
        case .center:
            UIView.animate(withDuration: popViewConfig.animateDuration, animations: {
                self.contentView?.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            }) { (finished) in
                block?()
            }
            return
        default:
            break
        }
        UIView.animate(withDuration: popViewConfig.animateDuration, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            block?()
        }
    }
    
}

// MARK: ------------------------- UIView+extension
public extension UIView {
    /// SwifterSwift: Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
