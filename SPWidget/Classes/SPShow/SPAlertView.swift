//
//  SPAlertView.swift
//  SPWidget
//
//  Created by flowerflower on 2021/12/15.
//

public typealias DismissCallback = () -> Void
public typealias BottomCallback = () -> Void
public typealias LeftCallBack = () -> Void
public typealias RightCallback = () -> Void

import Foundation

class SPAlertView: UIView{
    
    
    private var alertConfig : ShowAlertConfig
    
    var dismissBlock : DismissCallback?
    var bottomBtnBlock : BottomCallback?
    
    var leftBlock : LeftCallBack?
    var rightBlock : RightCallback?
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = alertConfig.titleColor
        titleLabel.font = alertConfig.titleFont
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var messageLabel : UILabel = {
        let messageLabel = UILabel.init()
        messageLabel.backgroundColor = .clear
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = alertConfig.messageColor
        messageLabel.font = alertConfig.messageFont
        return messageLabel
    }()
    
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = alertConfig.buttonSpacing
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var leftBtn : UIButton = {
        let leftBtn = UIButton.init(type: .custom)
        leftBtn.titleLabel?.font = alertConfig.buttonFont
        leftBtn.setTitleColor(alertConfig.leftBtnTitleColor, for: .normal)
        leftBtn.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        leftBtn.backgroundColor = alertConfig.leftBtnBgColor
        return leftBtn
    }()
    
    private lazy var rightBtn : UIButton = {
        let rightBtn = UIButton.init(type: .custom)
         rightBtn.titleLabel?.font = alertConfig.buttonFont
         rightBtn.setTitleColor(alertConfig.rightBtnTitleColor, for: .normal)
         rightBtn.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        rightBtn.backgroundColor = alertConfig.rightBtnBgColor
        return rightBtn
    }()
    
    init(title: String? = nil,
         attributedTitle : NSAttributedString? = nil,
         message: String?  = nil,
         attributedMessage : NSAttributedString? = nil,
         leftBtnTitle: String? = nil,
         leftBtnAttributedTitle: NSAttributedString? = nil,
         rightBtnTitle: String? = nil,
         rightBtnAttributedTitle: NSAttributedString? = nil,
         config : ShowAlertConfig) {
        
        alertConfig = config
        
        super.init(frame: CGRect.zero)
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: alertConfig.effectStyle))
        addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        switch alertConfig.maskType {
        case .effect:
            effectView.isHidden = false
            backgroundColor = .clear
        default:
            effectView.isHidden = true
            backgroundColor = alertConfig.bgColor
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeClick))
        self.addGestureRecognizer(tap)
        let containerView = UIView.init()
        addSubview(containerView)
        containerView.backgroundColor = alertConfig.tintColor
        containerView.layer.cornerRadius = alertConfig.cornerRadius
        if alertConfig.shadowColor != UIColor.clear.cgColor {
            containerView.layer.shadowColor = alertConfig.shadowColor
            containerView.layer.shadowOpacity = alertConfig.shadowOpacity
            containerView.layer.shadowRadius = alertConfig.shadowRadius
            containerView.layer.shadowOffset = CGSize.zero
        }
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(alertConfig.maxWidth)
            make.height.lessThanOrEqualTo(alertConfig.maxHeight)
        }
        

        if let att = attributedTitle{
            titleLabel.attributedText = att
        }else{
            titleLabel.text = title
        }
        
        containerView.addSubview(titleLabel)
       titleLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().offset(alertConfig.titleTopSpacing)
            make.left.right.equalToSuperview()
        }
        

        if let att = attributedMessage{
            messageLabel.attributedText = att
        }else{
            messageLabel.text = message
        }
        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(alertConfig.messageTopSpacing)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
         }
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        containerView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(config.leftBtnSpacing)
            make.right.equalToSuperview().offset(-config.rightBtnSpacing)
            make.height.equalTo(alertConfig.buttonHeight)
            make.bottom.equalToSuperview().offset(-config.bottomSpacing)
        }
        
        
        if leftBtnTitle != nil || leftBtnAttributedTitle != nil {
            if let att = leftBtnAttributedTitle{
                leftBtn.setAttributedTitle(att, for: .normal)
            }else{
                leftBtn.setTitle(leftBtnTitle, for: .normal)
            }
            
            buttonStackView.addArrangedSubview(leftBtn)
        }
      

        
        if rightBtnTitle != nil || rightBtnAttributedTitle != nil {
            if let att = rightBtnAttributedTitle{
                rightBtn.setAttributedTitle(att, for: .normal)
            }else{
                rightBtn.setTitle(rightBtnTitle, for: .normal)
            }
            buttonStackView.addArrangedSubview(rightBtn)
        }
        if config.lineHeight > 0{
            let hLineView = UIView()
            hLineView.backgroundColor = config.lineColor
            buttonStackView.addSubview(hLineView)
            hLineView.snp.makeConstraints{
                $0.left.right.equalToSuperview()
                $0.height.equalTo(config.lineHeight)
                $0.top.equalToSuperview()
            }
            
            if rightBtnTitle != nil || rightBtnAttributedTitle != nil {
                let vLineView = UIView()
                vLineView.backgroundColor = config.lineColor
                buttonStackView.addSubview(vLineView)
                vLineView.snp.makeConstraints{
                    $0.top.bottom.equalToSuperview()
                    $0.width.equalTo(config.lineHeight)
                    $0.centerX.equalToSuperview()
                }
            }
        }       
        if config.buttonRadius > 0 {
            leftBtn.layer.cornerRadius = config.buttonRadius
            leftBtn.layer.masksToBounds = true
            rightBtn.layer.cornerRadius = config.buttonRadius
            rightBtn.layer.masksToBounds = true
        }
                
        if config.leftBtnBorderWidth > 0 {
            leftBtn.layer.borderWidth = config.leftBtnBorderWidth
            
            leftBtn.layer.borderColor = config.leftBtnBorderColor.cgColor
        }
        if config.rightBtnBorderWidth > 0 {
            rightBtn.layer.borderWidth = config.rightBtnBorderWidth
            rightBtn.layer.borderColor = config.rightBtnBorderColor.cgColor
        }
        
    }
  

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func closeClick(){
        if alertConfig.clickOtherHidden {
            dismiss()
        }
    }
    @objc
    func leftClick() {
        dismiss()
        guard let block = leftBlock else {
            return
        }
        block()
    }
    @objc
    func rightClick() {
        dismiss()
        guard let block = rightBlock else {
            return
        }
        block()
    }
    @objc func bottomBtnClick() {
        
        dismiss()
        guard let block = bottomBtnBlock else {
            return
        }
        block()
    }
    
    @objc  func dismiss() {
        guard let block = dismissBlock else {
            return
        }
        block()
    }
}

