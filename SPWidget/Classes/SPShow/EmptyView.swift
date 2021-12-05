//
//  EmptyView.swift
//  SwiftProject
//
//  Created by flowerflower on 2021/10/17.
//

import UIKit


public enum EmptyType{
  case  noData    //无数据
  case  nonetwork //无错误
  case  serverError  //服务器异常
}

// MARK: ------------------------- Const/Enum/Struct

extension EmptyView {
    
    /// 常量
    struct Const {}
    
    /// 内部属性
    struct Porpertys {}
    
    /// 外部参数
    struct Params {}
    
}

public class EmptyView: UIView {
    
    // MARK: ------------------------- Propertys
    
    
    // MARK: ------------------------- CycLife
    
    // MARK: ------------------------- Events
    
    // MARK: ------------------------- Methods
    
    func showEmptyView(emptyType: EmptyType){
        
        
    }
    
    
    
}

