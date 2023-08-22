//
//  ClubListRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation
import UIKit

enum ClubListNavigationDestination {
    case goWeb(URLRequest)
}

protocol ClubListsRouterInterface {
    func navigate(_ destination: ClubListNavigationDestination)
}

final class ClubListsRouter: BaseRouter, ClubListsRouterInterface {
    init() {
        let viewController = R.storyboard.clubLists.clubListsViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = ClubListsViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self)
        )
    }

    func navigate(_ destination: ClubListNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        }
    }
}