//
//  UIControlPublishers.swift
//
//  Created by Eden on 2023/4/14.
//

import UIKit
import Combine

public
protocol UIControlPublishers where Self: UIControl { }

extension UIControl: UIControlPublishers { }

// MARK: - EventPublisher -

public
extension UIControlPublishers
{
    func eventPublisher(_ event: Event) -> AnyPublisher<Self, Never>
    {
        EventPublisher(control: self, events: event)
            .eraseToAnyPublisher()
    }
}

// MARK: - PropertyPublisher -

public
extension UIControlPublishers
{
    func propertyPublisher<Value>(_ event: Event, keyPath: KeyPath<Self, Value>) -> AnyPublisher<Value, Never>
    {
        PropertyPublisher(control: self, events: event, keyPath: keyPath)
            .map(\.1)
            .eraseToAnyPublisher()
    }
}
