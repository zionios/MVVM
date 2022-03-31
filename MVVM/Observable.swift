//
//  Observable.swift
//  MVVM
//
//  Created by 성준 on 2022/03/28.
//

import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            listner?(value)
        }
    }
    
    private var listner: ((T?) ->  Void)?
    
    init(value: T?) {
        self.value = value
    }
    
    func bind(_ listner: @escaping (T?) -> Void) {
        listner(value) //바인딩과 동시에 value방출
        self.listner = listner
    }
}
