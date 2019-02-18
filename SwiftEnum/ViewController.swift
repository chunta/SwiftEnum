//
//  ViewController.swift
//  SwiftEnum
//
//  Created by nmi on 2019/2/18.
//  Copyright © 2019 nmi. All rights reserved.
//

import UIKit
import Alamofire
import Cartography

enum ViewState<Content> {
    case none
    case loading
    case loaded(data:Content)
    case error(message:String)
}

class LoadingView:UIView {
    
}

class ErrorView:UIView {
    
}

protocol DataLoading {
    associatedtype Data
    var state: ViewState<Data> {get set}
    var loadingView: LoadingView {get}
    var errorView:ErrorView {get}
    
    func update()
}

extension DataLoading where Self: UIView {
    
    func update(){
       switch state {
       case .none:
            loadingView.isHidden = true
            errorView.isHidden = true
       case .loading:
            loadingView.isHidden = false
            errorView.isHidden = true
       case .error(let error):
            loadingView.isHidden = true
            errorView.isHidden = false
            print(error)
       case .loaded:
            loadingView.isHidden = true
            errorView.isHidden = true
       }
    }
}

class MainView: UIView, DataLoading {
    var loadingView: LoadingView
    var errorView: ErrorView
    var state: ViewState<String> = .none {
        didSet {
            update()
        }
    }
    
    init( rect:CGRect) {
        loadingView = LoadingView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        errorView = ErrorView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        super.init(frame: rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        loadingView = LoadingView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        errorView = ErrorView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        super.init(coder: aDecoder)
    }
    
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let m01:MainView = MainView.init( rect: CGRect(x: 10, y: 220, width: 100, height: 66))
        m01.backgroundColor = UIColor.purple
        self.view.addSubview(m01)
        
        let m02:MainView = MainView.init(rect: CGRect(x: 0, y: 0, width: 60, height: 33))
        m02.backgroundColor = UIColor.yellow
        self.view.addSubview(m02)
        
        constrain(m02) {view in
            view.size   == view.superview!.size / 2
            view.center == view.superview!.center
        }
        
        Alamofire.request("https://www.apple.com/tw/").responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                print(String(data: data, encoding: .utf8)!)
                m01.state = ViewState.loaded(data: String(data: data, encoding: .utf8)!)
                m01.state = ViewState.error(message: "apple.com")
            case .failure(let error):
                print(error)
                m01.state = ViewState.error(message: error.localizedDescription)
            }
        })
        
        Alamofire.request("https://google.com").responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                print(String(data: data, encoding: .utf8)!)
                m02.state = ViewState.loaded(data: String(data: data, encoding: .utf8)!)
                m02.state = ViewState.error(message: "google.com")
            case .failure(let error):
                print(error)
                m02.state = ViewState.error(message: error.localizedDescription)
            }
        })
        
        
    }


}

