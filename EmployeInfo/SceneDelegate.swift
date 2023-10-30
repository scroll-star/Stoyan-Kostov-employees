//
//  SceneDelegate.swift
//  EmployeInfo
//
//  Created by Stoyan Kostov on 29.10.23.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    private func configureWindow() {
        let viewController = Self.makeViewController()
        let presenter = Presenter(viewController: viewController)

        viewController.processDocumentHandler = presenter.processCSVFile(at:)

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    private static func makeViewController() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedController = storyboard.instantiateInitialViewController() as! ViewController
        return feedController
    }
}
