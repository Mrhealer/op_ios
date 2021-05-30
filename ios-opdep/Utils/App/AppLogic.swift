//
//  AppLogic.swift

import UIKit

final class AppLogic: NSObject, UNUserNotificationCenterDelegate {
    static var shared: AppLogic {
        (UIApplication.shared.delegate as? AppDelegate)!.appLogic
    }
    
    weak var appDelegate: AppDelegate?
    let application: UIApplication
    let storage: LocalStorage
    let launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    var appRouter: AppRouter
        
    init(appDelegate: AppDelegate,
         application: UIApplication,
         launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
         appRouter: AppRouter,
         storage: LocalStorage) {
        self.appDelegate = appDelegate
        self.application = application
        self.launchOptions = launchOptions
        self.storage = storage
        self.appRouter = appRouter
    }
    
    func startSetup() {
        setUpApiService()
    }
    
    func startUserSession() {
        appRouter.resetToHome(tab: .home)
    }
}

// MARK: - Application lifecycle
extension AppLogic {
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Application will terminate")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Application will enter foreground")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application enter background")
    }
}

// MARK: - Global API Error
protocol APIErrorCatchable {
    func processAPIError(_ error: APIError) -> Bool
}

extension AppLogic: APIErrorCatchable {
    func processAPIError(_ error: APIError) -> Bool {
        guard case .unauthorized = error else { return true }
        appRouter.presentAuthenticationPrompt()
        return false
    }
}

// MARK: - Services configuration

private extension AppLogic {
    
    func setUpNetworkMonitoring() {
        NetworkStatus.shared.startNetworkReachabilityObserver()
    }
    
    func setUpApiService() {
        APIService.set(environment: AppSettings.environment,
                       keyStore: LocalStorage(),
                       errorHandler: self)
        
    }
}
