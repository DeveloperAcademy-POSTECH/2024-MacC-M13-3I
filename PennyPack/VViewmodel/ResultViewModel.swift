//
//  ResultViewModel.swift
//  PennyPack
//
//  Created by siye on 12/31/24.
//

import Foundation

final class ResultViewModel: ObservableObject{
    func resetPath(pathRouter: PathRouter) {
        pathRouter.removeAll()
    }
}
