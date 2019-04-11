//
//  ViewModel.swift
//  MVVM
//
//  Created by Aaron on 2019/4/11.
//  Copyright © 2019 Aaron. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TransformViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

protocol SubjectViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input {get}
    var output: Output {get}
}

final class TransformViewModel: TransformViewModelType {
    
    struct Input {
        let message: Observable<String>
        let send: Observable<Void>
    }
    
    struct Output {
        let result: Driver<String>
    }
    
    func transform(input: TransformViewModel.Input) -> TransformViewModel.Output {
        let result = input.send
            .withLatestFrom(input.message)
            .map { (message) -> String in
                return "viewModel1: \(message)"
            }
            .startWith("result1")
            .asDriver(onErrorJustReturn: "")
        return Output.init(result: result)
    }
    
}

class SubjectViewModel: SubjectViewModelType {
    
    var input: SubjectViewModel.Input
    var output: SubjectViewModel.Output
    
    struct Input {
        let message: AnyObserver<String>
        let send: AnyObserver<Void>
    }
    
    struct Output {
        let result: Driver<String>
    }
    
    private let messageSubject = PublishSubject<String>()
    private let sendSubject = PublishSubject<Void>()
    
    init() {
        
        let result = sendSubject
            .withLatestFrom(messageSubject)
            .map { (message) -> String in
                return "viewModel2: \(message)"
            }
            .startWith("result2")
            .asDriver(onErrorJustReturn: "")
        input = Input.init(message: messageSubject.asObserver(), send: sendSubject.asObserver())
        output = Output.init(result: result)
    }
    
}

