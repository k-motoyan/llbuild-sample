//
//  MyTask.swift
//  llbuild-sample
//
//  Created by 本柳賢太 on 2017/11/16.
//  Copyright © 2017年 k-motoyan. All rights reserved.
//

final class MyTask: Task {

    private let inputs: [Key]
    private let compute: Compute

    init(_ inputs: [Key], _ compute: @escaping Compute) {
        self.inputs = inputs
        self.compute = compute
    }

    func start(_ engine: TaskBuildEngine) {
        for (i, input) in inputs.enumerated() {
            engine.taskNeedsInput(input, inputID: i)
        }
    }

    func provideValue(_ engine: TaskBuildEngine, inputID: Int, value: Value) {
    }

    func inputsAvailable(_ engine: TaskBuildEngine) {
        compute()
        engine.taskIsComplete(Value(""), forceChange: false)
    }

}

