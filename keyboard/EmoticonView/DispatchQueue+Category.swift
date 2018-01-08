//
//  DispatchQueue+Category.swift
//  keyboard
//
//  Created by JinShiJinSheng on 2018/1/8.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//
import UIKit

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    private static var _onceToken = NSUUID().uuidString
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func onceToken(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
    public class func once(block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(_onceToken) {
            return
        }
        _onceTracker.append(_onceToken)
        block()
    }
}
