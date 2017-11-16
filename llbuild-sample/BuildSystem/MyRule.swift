//
//  MyRule.swift
//  llbuild-sample
//
//  Created by 本柳賢太 on 2017/11/16.
//  Copyright © 2017年 k-motoyan. All rights reserved.
//

final class MyRule: Rule {

    private let inputs: [Key]
    private let compute: Compute

    init(_ inputs: [Key], _ compute: @escaping Compute) {
        self.inputs = inputs
        self.compute = compute
    }

    func createTask() -> Task {
        return MyTask(inputs, compute)
    }

}

