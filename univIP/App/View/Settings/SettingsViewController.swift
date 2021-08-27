//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    private let model = Model()
    // セルの内容が入る
    private var cellList:[[String]] = [["図書館サイト",
                                        "シラバス",
                                        "時間割",
                                        "今年の成績表",
                                        "出欠記録"],
                                       ["パスワード設定",
                                        "このアプリについて",
                                        "開発者へ連絡"]]
    // セクションの高さ
    private var sectionHight:Int = 50
    // セルの高さ
    private var cellHight:Int = 100
    
    var delegateMain : MainViewController?
    var delegatePass : PasswordSettingsViewController?

    
    //MARK:- LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        viewAnimated(scene: "settingsViewAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // MARK: - TableView
    
    /// セルを選択した時のイベントを追加
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false, completion: nil)
        
        guard let delegate = delegateMain else {
            return
        }
//        delegate.restoreView()

        
        if (indexPath[0] == 0){
            switch indexPath[1] {
            case 0: // 図書館サイト
                delegate.openUrl(urlForRegistrant: model.libraryLoginURL, urlForNotRegistrant: nil, alertTrigger: false)
            case 1: // シラバス
                delegate.popupView(scene: "syllabus")
            case 2: // 時間割
                delegate.openUrl(urlForRegistrant: model.timeTableURL, urlForNotRegistrant: nil, alertTrigger: true)
            case 3: // 今年の成績
                let current = Calendar.current
                var year = current.component(.year, from: Date())
                let month = current.component(.month, from: Date())
                
                if (month <= 3){ // 1月から3月までは前年の成績であるから
                    year -= 1
                }
                
                let termPerformanceYearURL = model.currentTermPerformanceURL + String(year)
                delegate.openUrl(urlForRegistrant: termPerformanceYearURL, urlForNotRegistrant: nil, alertTrigger: true)
            case 4: // 出欠記録
                delegate.openUrl(urlForRegistrant: model.presenceAbsenceRecordURL, urlForNotRegistrant: nil, alertTrigger: true)
            default:
                return
            }
        }else if(indexPath[0] == 1){
            switch indexPath[1] {
            case 0: // パスワード設定
                delegate.popupView(scene: "password")
            case 1: // このアプリについて
                delegate.popupView(scene: "aboutThisApp")
            case 2: // 開発者へ連絡
                delegate.popupView(scene: "contactToDeveloper")
            default:
                return
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        viewAnimated(scene: "settingsViewDisappear")
//        delegate.animationView(scene: "restoreView")
    }

    /// セクション内のセル数を決めるメソッド（＊＊必須＊＊）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList[Int(section)].count
    }
    
    /// セルのインスタンスを生成するメソッド「表示するcellの中身を決める」（＊＊必須＊＊）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TableCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        TableCell.textLabel!.text = cellList[indexPath.section][Int(indexPath.item)]
        TableCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator // ここで「>」ボタンを設定
        return TableCell
    }

    /// テーブル内のセクション数を決めるメソッド
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellList.count
    }

    /// セクションの高さを設定
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(sectionHight)
    }

    /// セルの高さを決めるメソッド
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHight)
    }
    
    //MARK:- Private func
    private func viewAnimated(scene:String){
        switch scene {
        case "settingsViewAppear":
            // メニューの位置を取得する
            let menuPos = self.tableView.layer.position
            // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
            self.tableView.layer.position.x = -self.tableView.frame.width
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.tableView.layer.position.x = menuPos.x
            },
                completion: { bool in
            })
        case "settingsViewDisappear":
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    self.tableView.layer.position.x = -self.tableView.frame.width
                },
                completion: { _ in
                    self.dismiss(animated: false, completion: nil)
                }
            )
        default:
            return
        }
    }
    

    
    //MARK:- Override(Animate)

    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                viewAnimated(scene: "settingsViewDisappear")
            }
        }
    }
}


