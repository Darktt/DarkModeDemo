//
//  EventPublisher.swift
//  SVGAPlayerDemo
//
//  Created by Eden on 2023/4/14.
//

import UIKit.UIControl
import Combine

// MARK: - EventPublisher -

public
struct EventPublisher<Control>: Publisher where Control: UIControl
{
    public
    typealias Output = Control
    
    public
    typealias Failure = Never
    
    // MARK: - Properties -
    
    private
    let control: Control
    
    private
    let events: Control.Event
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    /// - parameter control: UIControl.
    /// - parameter events: UIControl Events.
    public
    init(control: Control, events: Control.Event)
    {
        self.control = control
        self.events = events
    }
    
    public
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output
    {
        let subscription = Subscription(subscriber: subscriber, control: self.control, events: self.events)
        
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Subscription -

private final
class Subscription<S: Subscriber, Control: UIControl>: Combine.Subscription where S.Input == Control
{
    // MARK: - Properties -
    private
    var subscriber: S?
    
    private
    weak var control: Control?
    
    private
    let events: Control.Event
    
    init(subscriber: S, control: Control, events: Control.Event)
    {
        self.subscriber = subscriber
        self.control = control
        self.events = events
        
        control.addTarget(self, action: #selector(self.event), for: events)
    }
    
    func cancel()
    {
        self.control?.removeTarget(self, action: #selector(self.event), for: self.events)
        self.subscriber = nil
    }
    
    func request(_ demand: Subscribers.Demand)
    {
        
    }
    
    @objc private
    func event()
    {
        guard let control = self.control else {
            
            return
        }
        
        _ = self.subscriber?.receive(control)
    }
}
