//
//  MyBuildEngineDelegate.swift
//  llbuild-sample
//
//  Created by 本柳賢太 on 2017/11/16.
//  Copyright © 2017年 k-motoyan. All rights reserved.
//

import Foundation

final class MyBuildEngineDelegate: BuildEngineDelegate {

    private var env: [String: String] {
        return ProcessInfo.processInfo.environment
    }

    private var rootDir: String {
        guard let rootDir = env["ROOT_PATH"] else {
            fatalError("undefined environment:ROOT_PATH")
        }

        return rootDir
    }

    private var buildDir: String {
        return rootDir + "/.build"
    }

    private var mainPath: String {
        return rootDir + "/sample-build-project/main.swift"
    }

    private let compileCmd = "swiftc"

    func lookupRule(_ key: Key) -> Rule {
        switch key.toString() {
        case BuildKey.initialize.rawValue:
            return MyRule([]) {
                guard !FileManager.default.fileExists(atPath: self.buildDir) else {
                    return
                }

                self.mkdir(path: self.buildDir + "/.build")
            }

        case BuildKey.compile.rawValue:
            let inputs = [
                Key(BuildKey.initialize.rawValue)
            ]

            return MyRule(inputs) {
                let args = [self.mainPath, "-o \(self.buildDir)/sample"]
                self.exec(cmd: self.compileCmd, args: args)
            }

        case BuildKey.run.rawValue:
            let inputs = [
                Key(BuildKey.initialize.rawValue),
                Key(BuildKey.compile.rawValue)
            ]

            return MyRule(inputs) {
                let output = self.exec(cmd: "\(self.buildDir)/sample", args: [])
                print(output)
            }

        default:
            fatalError("unexpected key.")

        }
    }

    private func mkdir(path: String) {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }

    @discardableResult
    private func exec(cmd: String, args: [String]) -> String {
        let process = Process()

        process.launchPath = env["SHELL"]!
        process.arguments = ["-lc", ([cmd] + args).joined(separator: " ")]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }

}

