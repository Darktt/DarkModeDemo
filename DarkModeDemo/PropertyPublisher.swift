//
//  PropertyPublisher.swift
//
//  Created by Eden on 2023/4/13.
//

import UIKit.UIControl
import Combine

// MARK: - PropertyPublisher -

struct PropertyPublisher<Control, Value>: Publisher where Control: UIControl
{
    public
    typealias Output = (Control, Value)
    
    public
    typealias Failure = Never
    
    // MARK: - Properties -
    private
    let control: Control
    
    private
    let events: Control.Event
    
    private
    let keyPath: KeyPath<Control, Value>
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    /// - parameter control: UIControl.
    /// - parameter events: UIControl Events.
    /// - parameter keyPath: A Key Path from the UI Control to the requested value.
    public
    init(control: Control, events: Control.Event, keyPath: KeyPath<Control, Value>)
    {
        self.control = control
        self.events = events
        self.keyPath = keyPath
    }
    
    public
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output
    {
        let subscription = Subscription(subscriber: subscriber, control: self.control, events: self.events, keyPath: self.keyPath)
        
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Subscription -

private final
class Subscription<S, Control, Value>: Combine.Subscription where S: Subscriber, S.Input == (Control, Value), Control: UIControl
{
    // MARK: - Properties -
    private
    var subscriber: S?
    
    private
    weak var control: Control?
    
    private
    let events: Control.Event
    
    private
    let keyPath: KeyPath<Control, Value>
    
    private
    var initialWasFired: Bool = false
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    init(subscriber: S, control: Control, events: Control.Event, keyPath: KeyPath<Control, Value>)
    {
        self.subscriber = subscriber
        self.control = control
        self.events = events
        self.keyPath = keyPath
        
        control.addTarget(self, action: #selector(self.event), for: events)
    }
    
    func cancel()
    {
        self.control?.removeTarget(self, action: #selector(self.event), for: self.events)
        self.subscriber = nil
    }
    
    func request(_ demand: Subscribers.Demand)
    {
        guard let control = self.control,
                let subscriber = self.subscriber,
                !self.initialWasFired else {
            
            return
        }
        
        _ = subscriber.receive((control, control[keyPath: keyPath]))
        self.initialWasFired = true
    }
    
    @objc private
    func event()
    {
        guard let control else {
            
            return
        }
        
        _ = subscriber?.receive((control, control[keyPath: keyPath]))
    }
}
