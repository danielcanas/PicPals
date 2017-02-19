//
//  GlobalVariables.swift
//  PicPals
//
//  Created by Fulton Garcia on 2/18/17.
//  Copyright © 2017 Fulton Garcia. All rights reserved.
//

import Foundation

class GlobalVariables {
    
    // These are the properties you can store in your singleton
    public var myName: String = ""
    
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
