//
//  NewsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit
import FirebaseAnalytics

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = NewsViewModel()
    private let dataManager = DataManager.singleton
    // 読み込み中のクルクル(ビジーカーソルともいう)
    private var viewActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
        layoutInitSetting()
        
        viewModel.getNewsData()
    }
    
    // ステータスバーの文字を白に設定
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
    // MARK: - Private func
    /// ViewModel初期化
    private func initViewModel() {
        // Protocol： ViewModelが変化したことの通知を受けて画面を更新する
        self.viewModel.state = { [weak self] (state) in
            guard let self = self else {
                fatalError()
            }
            DispatchQueue.main.async {
                switch state {
                    case .busy: // 通信中
                        self.viewActivityIndicator.startAnimating() // クルクルスタート
                        break
                        
                    case .ready: // 通信完了
                        self.viewActivityIndicator.stopAnimating() // クルクルストップ
                        self.tableView.reloadData()
                        break
                        
                    case .error:
                        break
                }
            }
        }
    }
    
    private func layoutInitSetting() {
        // ステータスバーの背景色を指定
        setStatusBarBackgroundColor(UIColor(red: 13/255, green: 58/255, blue: 151/255, alpha: 1.0))
        
        // ActivityIndicator
        viewActivityIndicator = UIActivityIndicatorView()
        viewActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        viewActivityIndicator.center = self.view.center
        viewActivityIndicator.hidesWhenStopped = true
        viewActivityIndicator.style = UIActivityIndicatorView.Style.medium
        self.view.addSubview(viewActivityIndicator)
        
        // TableView
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "NewsTableViewCell")
    }
}


extension NewsViewController: UITableViewDelegate,UITableViewDataSource {
    // セクションの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // セルの数
    func numberOfSections(in tableView: UITableView) -> Int {
        // 取得数が1未満であれば、データ取得に失敗していると判定し0個を返す
        if 1 < viewModel.newsDatas.count {
            return viewModel.newsDatas.count
        } else {
            return 0
        }
        
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    // セル背景色
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.newsTableViewCell, for: indexPath)!
        
        // タイトルや画像は別々で取得してくるため、配列内に必ずあるとは限らないため
        if 1 < viewModel.newsDatas.count {
            let text = viewModel.newsDatas[indexPath.section].title
            let date = viewModel.newsDatas[indexPath.section].date
            var imgUrlStr = "NoImage"
            
            if imgUrlStr == "https://www.tokushima-u.ac.jp/assets/img/dummy.png" {
                imgUrlStr = "NoImage"
            }
                
            cell.setupCell(text: text,
                           date: date)
        }
        
        return cell
    }
    
    
    /// セルを選択時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Analytics.logEvent("NewsTable", parameters: nil) // Analytics
        // セルの選択状態を解除
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let vcWeb = R.storyboard.web.webViewController()!
        let loadUrlString = viewModel.newsDatas[indexPath[0]].urlStr
        vcWeb.loadUrlString = loadUrlString
        present(vcWeb, animated: true, completion: nil)
    }
}
