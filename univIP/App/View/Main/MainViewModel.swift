//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation

final class MainViewModel: NSObject {
    class WebViewOperation {
        var cAcount: String = ""
        var password: String = ""
        
        func login() {
            
        }
        
//        init(<#parameters#>) {
//            color =
//        }
    }
    
    //let passo = car(color: red, )
    
    
    //MARK: - STATE ステータス
    enum State {
        case busy           // 準備中
        case ready          // 準備完了
        case error          // エラー発生
    }
    public var state: ((State) -> Void)?
    
    //MARK: - STATE ステータス
    enum NextView {
        case syllabus           // 準備中
        case password
        case aboutThisApp
        case contactToDeveloper
    }
    public var next: ((NextView) -> Void)?
    
    enum IconEnum: String {
        case spIcon = "spIcon"
        case pcIcon = "pcIcon"
        case other = "other"
    }
    
    private let dataManager = DataManager()
    private let model = Model()
    private let urlModel = UrlModel()
    private var requestUrl: NSURLRequest?
    
    public var host = ""
    public var displayUrl = ""
    public var forwardDisplayUrl = ""
    
    public var imageSystemName = ""
    public var animationView = ""
    //  SyllabusViewの内容を渡され保存し、Webに入力する
    public var syllabusSubjectName = ""
    public var syllabusTeacherName = ""
    public var syllabusKeyword = ""
    public var syllabusSearchOnce = true
    
    public var cAccount = "c611821006"
    public var password = "q2KF2ZaxPtkL7Uu"
    public var mailAdress = ""
    
    public var reversePCtoSPIconName = "pcIcon"
    public var reversePCtoSPIsEnabled = false
//    var url: String
//    var isTopView: Bool
//    var isAllowTwoTimesView: Bool
    
    enum Menu {
        case courceManagement
        case manaba
    }
    
    public func isDisplayUrlForPC() -> String { // boolにしたい
        
        switch displayUrl {
        case urlModel.courceManagementHomeSP:
            UserDefaults.standard.set("pc", forKey: "CMPCtoSP")
            return R.image.spIcon.name
            
            
        case urlModel.courceManagementHomePC:
            UserDefaults.standard.set("sp", forKey: "CMPCtoSP")
            return R.image.pcIcon.name
            
            
        case urlModel.manabaSP:
            UserDefaults.standard.set("pc", forKey: "ManabaPCtoSP")
            return R.image.spIcon.name
            
            
        case urlModel.manabaPC:
            UserDefaults.standard.set("sp", forKey: "ManabaPCtoSP")
            return R.image.pcIcon.name
            
            
        default:
            return "No Image"
        }
    }
    
    public func tabBarDetection(num: Int) -> NSURLRequest? {
        
        switch num {
        case 1: // 左
            if UserDefaults.standard.string(forKey: "CMPCtoSP") == "pc"{
                return urlModel.url(.courceManagementHomePC).1
                
            }else{
                return urlModel.url(.courceManagementHomeSP).1
                
            }
            
            
        case 2: // 右
            if UserDefaults.standard.string(forKey: "ManabaPCtoSP") == "pc"{
                return urlModel.url(.manabaPC).1
                
            }else{
                return urlModel.url(.manabaSP).1

            }
            
        default:
            return nil
        }
    }
    
    
    public func openUrl(_ registrant: String, notRegistrant: String = "", isAlert: Bool = false) -> NSURLRequest? {
        //        webViewDisplay(bool: true)
        
        var notRegi = notRegistrant
        if notRegistrant == "" {
            notRegi = registrant
        }
        
        // 登録者判定
        if isRegistrant(){
            if let url = URL(string:registrant){
                return NSURLRequest(url: url)
                
            }
            
        }else{
            if let url = URL(string: notRegi){
                return NSURLRequest(url: url)
                
            }
            
//            if isAlert {
//                return nil
//            }
        }
        return nil
        
    }
    
    // アカウント登録者判定　登録者：true　　非登録者：false
    private func isRegistrant() -> Bool{
        if (dataManager.cAccount == "" &&
                dataManager.passWord == ""){
            return false
            
        }else{
            return true
        }
    }
    
    
    func viewPosisionType(posisionY: Double) {
        
        switch posisionY {
        case 0.0:
            imageSystemName = "chevron.up"
            animationView = "rightButtonUp"

            
        default:
            imageSystemName = "chevron.down"
            animationView = "rightButtonDown"
        }
        
    }
    
    func registrantDecision() -> Bool{
        if (dataManager.cAccount == "" &&
                dataManager.passWord == ""){
            return false
            
        }else{
            return true
        }
    }
    
    
    func isDomeinInspection(_ url: URL) -> Bool {
        guard let host = url.host else{
            AKLog(level: .ERROR, message: "ドメイン取得エラー")
            return false
        }
        var trigger = false
        for allow in model.allowDomains {
            if host.contains(allow){
                trigger = true
            }
        }
        return trigger
    }
    

    
    func judgeMobileOrPC() {
        
        if displayUrl == urlModel.courceManagementHomeSP ||
            displayUrl == urlModel.manabaSP {
            reversePCtoSPIconName = "pcIcon"
            reversePCtoSPIsEnabled = true
                        
        }else if displayUrl ==  urlModel.courceManagementHomePC ||
                    displayUrl == urlModel.manabaPC{
            reversePCtoSPIconName = "spIcon"
            reversePCtoSPIsEnabled = true

        }else{
            reversePCtoSPIsEnabled = false
            
        }
    }
    
    
    enum Scene {
        case login
        case enqueteReminder
        case syllabus
        case outlook
        case tokudaiCareerCenter
        case timeOut
        case registrantAndLostConnectionDecision
    }
    
    public func isJudgeUrl(_ scene: Scene) -> Bool {
        switch scene {
        case .login:
            let zero = !forwardDisplayUrl.contains(urlModel.lostConnection) // 前回のURLがログインURLではない = 初回
            let one = displayUrl.contains(urlModel.lostConnection)          // 今表示されているURLがログインURLか
            let second = displayUrl.suffix(2)=="s1"                         // 2回目は"=e1s2"　（zero があるが、安全策）
            let therd = registrantDecision()                                // 登録者判定
            if zero && one && second && therd {
                return true
            }
            return false
            
            
        case .enqueteReminder:
            let one = !forwardDisplayUrl.contains(urlModel.enqueteReminder)
            let second = displayUrl.contains(urlModel.enqueteReminder)
            if one && second {
                return true
            }
            return false
            
            
        case .syllabus:
            syllabusSearchOnce = false
            let one = displayUrl.contains(urlModel.syllabus)
            let second = syllabusSearchOnce
            if one && second {
                return true
            }
            return false
            
            
        case .outlook:
            let one = !forwardDisplayUrl.contains(urlModel.outlookLogin)
            let second = displayUrl.contains(urlModel.outlookLogin)
            if one && second {
                return true
            }
            return false
            
            
        case .tokudaiCareerCenter:
            let one = !forwardDisplayUrl.contains(urlModel.tokudaiCareerCenter)
            let second = displayUrl == urlModel.tokudaiCareerCenter
            if one && second {
                return true
            }
            return false
            
        
        case .timeOut:
            return displayUrl == urlModel.timeOut
        
        
        case .registrantAndLostConnectionDecision:
            return !registrantDecision() && displayUrl.contains(urlModel.lostConnection)
            
        }
    }
    
    
    public func registUrl(_ url: URL) {
        
        forwardDisplayUrl = displayUrl
        displayUrl = url.absoluteString
        
        print("displayURL : \(displayUrl)")
    }
    
    
    public func CMAndManabaPCtoMB() -> URLRequest? {
        if UserDefaults.standard.string(forKey: "CMPCtoSP") == "pc" {
            if displayUrl == urlModel.courceManagementHomeSP{
                let response = urlModel.url(.courseRegistration)
                if let url = response.1 as URLRequest? {
                    return url
                    
                }
            }
            
        } else {
            if displayUrl == urlModel.courceManagementHomePC {
                let response = urlModel.url(.courceManagementHomeSP)
                if let url = response.1 as URLRequest? {
                    return url
    
                }
            }
        }
        
        
        if UserDefaults.standard.string(forKey: "ManabaPCtoSP") == "pc"{
            if displayUrl == urlModel.manabaSP{
                let response = urlModel.url(.manabaPC)
                if let url = response.1 as URLRequest? {
                    return url
                    
                }
            }
            
        } else {
            if displayUrl == urlModel.manabaPC{
                let response = urlModel.url(.manabaSP)
                if let url = response.1 as URLRequest? {
                    return url
                    
                }
            }
        }
        return nil
        
    }
    
}
