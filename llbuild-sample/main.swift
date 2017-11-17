//
//  main.swift
//  llbuild-sample
//
//  Created by 本柳賢太 on 2017/11/02.
//  Copyright © 2017年 k-motoyan. All rights reserved.
//

import Foundation

typealias Compute = () -> Void

enum BuildKey: String { case initialize, compile }

let delegate = MyBuildEngineDelegate()
let engine = BuildEngine(delegate: delegate)

let key = Key(BuildKey.compile.rawValue)
_ = engine.build(key: key)

