//
//  SearchVC.swift
//  sofastcar
//
//  Created by Woobin Cheon on 2020/09/04.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit
import SnapKit
import NMapsMap

class SearchVC: UIViewController {
  
  let searchView = SearchView()
  //    let socarZoneData = SocarZoneData()
  var nMapAddress: [NMapAddress]?
  lazy var safeArea = self.view.safeAreaLayoutGuide
  var tempCnt = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupUI()
    setupConstraint()
  }
  
  // MARK: - Selector
  @objc func didTapBackButton(_ sender: UIButton) {
    guard let navi = self.presentingViewController as? UINavigationController else { return }
    guard let presentingVC = navi.viewControllers.last as? MainVC else { return }
    presentingVC.searchVCDismissFlag = true
    UIView.animate(withDuration: 0.5, animations: {
      
      presentingVC.topView.snp.updateConstraints({
        $0.top.equalTo(presentingVC.safeArea.snp.top).offset(8)
        $0.leading.equalTo(presentingVC.safeArea.snp.leading).offset(10)
        $0.trailing.equalTo(presentingVC.safeArea.snp.trailing).offset(-10)
        $0.height.equalTo(52)
      })
      presentingVC.searchView.snp.updateConstraints({
        $0.top.equalTo(presentingVC.safeArea.snp.top).offset(8)
        $0.leading.equalTo(presentingVC.safeArea.snp.leading).offset(0)
        $0.trailing.equalTo(presentingVC.safeArea.snp.trailing).offset(0)
        $0.height.equalTo(52)
      })
      
      presentingVC.searchView.shadowContainer.translatesAutoresizingMaskIntoConstraints = false
      presentingVC.searchView.shadowContainer.snp.updateConstraints({
        $0.height.equalTo(52)
      })
      
      self.searchView.alpha = 0
      self.view.backgroundColor = .clear
      presentingVC.whiteView.alpha = 0
      presentingVC.topView.alpha = 1
      presentingVC.searchView.alpha = 0
      presentingVC.setBookingTimeButton.frame.origin.y = presentingVC.view.frame.height - presentingVC.setBookingTimeButton.frame.height
      presentingVC.view.layoutIfNeeded()
    })
    presentingVC.dismiss(animated: true)
    
  }
  
  // MARK: - Setup UI
  private func setupUI() {
    searchView.layer.shadowOpacity = 0
    
    searchView.backButton.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
    
    searchView.searchTextField.delegate = self
    searchView.searchTextField.becomeFirstResponder()
    
    searchView.searchResultTableView.dataSource = self
    searchView.searchResultTableView.delegate = self
    searchView.searchResultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
    view.addSubview(searchView)
    
  }
  
  // MARK: - Setup Constraint
  private func setupConstraint() {
    searchView.translatesAutoresizingMaskIntoConstraints = false
    searchView.snp.makeConstraints({
      $0.top.equalTo(self.safeArea)
      $0.leading.equalTo(self.safeArea)
      $0.trailing.equalTo(self.safeArea)
      $0.bottom.equalTo(self.safeArea)
    })
    
    searchView.shadowContainer.translatesAutoresizingMaskIntoConstraints = false
    searchView.shadowContainer.snp.makeConstraints({
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.height.equalTo(60)
    })
  }
  
  deinit {
    searchView.searchTextField.resignFirstResponder()
  }
}

// MARK: - Extension
extension SearchVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tempCnt == 0 {
      let noDataView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
      let noDataLabel = UILabel()
      noDataLabel.text = "검색한 기록이 없습니다."
      noDataLabel.textColor = UIColor.systemGray2
      noDataView.addSubview(noDataLabel)
      tableView.backgroundView = noDataView
      tableView.separatorStyle = .none
      noDataLabel.translatesAutoresizingMaskIntoConstraints = false
      noDataLabel.snp.makeConstraints({
        $0.centerX.equalToSuperview()
        $0.centerY.equalToSuperview().dividedBy(3)
      })
    } else {
      
    }
    return tempCnt
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
    cell.separatorInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 20)
    //        if tempCnt == 0 {
    //            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    //            noDataLabel.text          = "No data available"
    //            noDataLabel.textColor     = UIColor.black
    //            noDataLabel.textAlignment = .center
    //            tableView.backgroundView  = noDataLabel
    //            tableView.separatorStyle  = .none
    //        } else {
    //        cell.setupConfiguration(placeName: socarZoneData.name.randomElement() ?? "이름 없음", placeAddr: socarZoneData.addr.randomElement() ?? "주소 없음", distanceFromMe: socarZoneData.distance.randomElement() ?? 0)
    //        }
    
    return cell
  }
}

extension SearchVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }
}

extension SearchVC: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    print(#function)
    //        if textField.text?.isEmpty ?? false {
    //            tempCnt = 0
    //            searchView.searchResultTableView.reloadData()
    //
    //        } else {
    //            tempCnt = 20
    //            searchView.searchResultTableView.reloadData()
    //        }1
  }
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    print(#function)
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    print(#function)
    guard let inputText = textField.text else { return true }
    
    let urlStr = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=\(inputText)&coordinate=127.1054328,37.3595963&count=30"
    if let encoded  = urlStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
      let myURL = URL(string: encoded) {
      var request = URLRequest(url: myURL)
      request.httpMethod = "GET"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("xexx2450ca", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
      request.addValue("4bFmMjWVoOtfqgfGxBdgtdiwJc3NZOGp8nK0YLik", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
      
      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
          print("Error", error.localizedDescription)
          return
        }
        // 오류 처리
        guard let header = response as? HTTPURLResponse,
          (200..<300) ~= header.statusCode,
          let responseData = data else { return }
        print(responseData)
        if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: AnyObject] {
          print(jsonObject)
          print(jsonObject["addresses"])
          print("==========")
          if let object = jsonObject["addresses"] as? [[String: AnyObject]] {
              print(object)
          } else {
            print("fial to change address")
          }
        } else {
          print("fail to serialization")
        }
      }
      task.resume()
    }
    
    return true
  }
}
