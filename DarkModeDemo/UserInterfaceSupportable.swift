//
//  UserInterfaceSupportable.swift
//
//  Created by Eden on 2022/5/23.
//

import Foundation
import UIKit

public protocol UserInterfaceSupportable
{
    var overrideUserInterfaceStyle: UIUserInterfaceStyle { get set }
}

public extension UserInterfaceSupportable
{
    var preferredStatusBarStyle: UIStatusBarStyle
    {
        switch self.overrideUserInterfaceStyle {
            
        case .unspecified:
            return .default
            
        case .light:
            return .darkContent
            
        case .dark:
            return .lightContent
            
        @unknown default:
            return .default
        }
    }
}
