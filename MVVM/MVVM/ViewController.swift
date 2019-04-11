//
//  ViewController.swift
//  MVVM
//
//  Created by Aaron on 2019/4/11.
//  Copyright © 2019 Aaron. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label_1: UILabel!
    @IBOutlet weak var label_2: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    private let viewModel1 = TransformViewModel()
    private let viewModel2 = SubjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bindModel1()
        bindModel2()
        
    }

    func bindModel1() {
        let input = TransformViewModel.Input.init(message: textField.rx.text.orEmpty.asObservable(),
                                                  send: sendButton.rx.tap.asObservable())
        let output = viewModel1.transform(input: input)
        output.result
            .drive(label_1.rx.text)
            .disposed(by: rx.disposeBag)
    }
    
    func bindModel2() {
        textField.rx.text.orEmpty
            .subscribe(viewModel2.input.message)
            .disposed(by: rx.disposeBag)
        sendButton.rx.tap
            .subscribe(viewModel2.input.send)
            .disposed(by: rx.disposeBag)
        viewModel2.output.result
            .drive(label_2.rx.text)
            .disposed(by: rx.disposeBag)
    }

}

