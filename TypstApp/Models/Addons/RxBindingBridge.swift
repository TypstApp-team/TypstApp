//
//  RxBindingBridge.swift
//  TypstApp
//
//  Created by TianKai Ma on 2023/11/16.
//

import Foundation
import SwiftUI
import RxSwift
import RxRelay

class BindingBridge<T> {
    @Binding var binding: T
    private let disposeBag = DisposeBag()
    
    var relay: BehaviorRelay<T> {
        didSet {
            relay.subscribe(onNext: { [weak self] newValue in
                self?.binding = newValue
            }).disposed(by: disposeBag)
        }
    }
    
    init(binding: Binding<T>) {
        self._binding = binding
        self.relay = .init(value: binding.wrappedValue)
    }
}
