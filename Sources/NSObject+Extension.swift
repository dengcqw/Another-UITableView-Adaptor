//
//  NSObject+Extension.swift
//  TVGuor
//
//  Created by Deng Jinlong on 2018/7/16.
//  Copyright © 2018 xiaoguo. All rights reserved.
//

import Foundation

extension NSObject {
    
    public var shortClassName: String {
        return fullClassName.components(separatedBy: ".").last ?? fullClassName
    }
    
    public class var shortClassName: String {
        return fullClassName.components(separatedBy: ".").last ?? fullClassName
    }
    
    public var fullClassName: String {
        return String(describing: type(of: self))
    }
    
    public class var fullClassName: String {
        return String(describing: self)
    }
    
}
