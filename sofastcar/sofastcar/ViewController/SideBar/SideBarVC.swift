//
//  SideBarVC.swift
//  sofastcar
//
//  Created by 김광수 on 2020/09/15.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit

enum SideBarMenuType: String {
  case eventBannerCell = ""
  case usingHistocyCell = "이용내역"
  case socarPassCell = "쏘카패스"
  case couponCell = "쿠폰"
  case evnetWithBenigitCell = "이벤트/해택"
  case socarPlusCell = "쏘카플러스"
  case inviteFriendCell = "친구 초대하기"
  case customerCenterCell = "고객센터"
  case mainBoardCell = "공지사항"
  
  static func allcase() -> [SideBarMenuType] {
    return [eventBannerCell, usingHistocyCell, socarPassCell, couponCell, evnetWithBenigitCell,
    socarPlusCell, inviteFriendCell, customerCenterCell, mainBoardCell]
  }
}

class SideBarVC: UIViewController {
  // MARK: - Properties
  let tableView = UITableView(frame: .zero, style: .plain)
  let viewWidthSizeRatio: CGFloat = 0.85
  let tableHeaderView = SideBarHeaderView(frame: .zero, isMain: true)
  let buttonImageName = ["business", "option", "plan"]
  lazy var sideBarCellTypes = SideBarMenuType.allcase()
  var isHorizenScrolling = false
  var isVerticalStcolling = false
  var gapX: CGFloat = 0
  var tableViewOriginX: CGFloat = 0
  var firstTouchOriginX: CGFloat = 0
  
  let sideBarBottonView = SideBarBottonView()
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black.withAlphaComponent(0)
    configureTableView()
    configureTableViewPanGuesture()
    configureBottomView()
  }
  
  private func configureTableView() {
    tableView.backgroundColor = .white
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableHeaderView = tableHeaderView
    tableView.tableHeaderView?.frame.size.height = 140
    tableView.separatorStyle = .none
    tableView.register(SideBarCustomCell.self, forCellReuseIdentifier: SideBarCustomCell.identifier)
    view.addSubview(tableView)
    tableView.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0.0,
                             width: UIScreen.main.bounds.width*viewWidthSizeRatio,
                             height: UIScreen.main.bounds.height)
    
    tableHeaderView.settingButton.addTarget(self, action: #selector(tapHaederButton(_:)), for: .touchUpInside)
    tableHeaderView.notiButton.addTarget(self, action: #selector(tapHaederButton(_:)), for: .touchUpInside)
    tableHeaderView.socarClubButton.addTarget(self, action: #selector(tapHaederButton(_:)), for: .touchUpInside)
  }
  
  private func configureTableViewPanGuesture() {
    let sideViewPanGuesture = UIPanGestureRecognizer(target: self, action: #selector(dragTableView(_:)))
    view.addGestureRecognizer(sideViewPanGuesture)
  }
  
  private func configureBottomView() {
    tableView.addSubview(sideBarBottonView)
    sideBarBottonView.snp.makeConstraints {
      $0.leading.trailing.equalTo(tableView.safeAreaLayoutGuide)
      $0.bottom.equalTo(tableView.safeAreaLayoutGuide).offset(50)
      $0.height.equalTo(120)
    }
    sideBarBottonView.businessButton.addTarget(self, action: #selector(tapButtomViewButton(_:)), for: .touchUpInside)
    sideBarBottonView.planButton.addTarget(self, action: #selector(tapButtomViewButton(_:)), for: .touchUpInside)
    sideBarBottonView.pairingButton.addTarget(self, action: #selector(tapButtomViewButton(_:)), for: .touchUpInside)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else { return }
    let touchPoint = touch.location(in: touch.view)  // 실제 터치한 위치
    if touchPoint.x > UIScreen.main.bounds.maxX * viewWidthSizeRatio {
      dismissWithAnimated(completion: nil)
    }
    
  }
  // MARK: - Custtom Present/Dismiss Animate
  func animateWithAnimate() {
    UIView.animate(withDuration: 0.5) {
      self.tableView.center.x += UIScreen.main.bounds.width
      self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
  }
  
  func dismissWithAnimated(completion: (() -> Void)?) {
    UIView.animate(withDuration: 0.5, animations: {
      self.tableView.center.x -= UIScreen.main.bounds.width
      self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
    }, completion: { success in
      if success {
        self.dismiss(animated: false, completion: nil)
        completion?()
      }
    })
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SideBarVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sideBarCellTypes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SideBarCustomCell.identifier)
      as? SideBarCustomCell else { fatalError() }
    cell.cellConfigure(cellType: sideBarCellTypes[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 55
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let navi = self.presentingViewController as? UINavigationController else { return }
    guard let mainVC = navi.viewControllers.last as? MainVC else { return }
    
    let cellType = sideBarCellTypes[indexPath.row]
    switch cellType {
    case .usingHistocyCell:
      dismissWithAnimated {
        let rentHistoryVC = RentHistoryVC(style: .grouped)
        mainVC.navigationController?.pushViewController(rentHistoryVC, animated: true)
      }
    case .evnetWithBenigitCell:
      dismissWithAnimated {
        let eventAndBenefitsVC = EventAndBenefitsVC()
        
        let eventArray = [
          EventBenifits.init(title: "쏘카마이존 EQC 이벤트", duration: "2020-09-28~2020-10-11", info: "평일엔 벤트 EQC를 내 차처럼"),
          EventBenifits.init(title: "코로나19 대응 안내", duration: "2020-09-28~2020-10-31", info: "안전한 이동이 필요한 순간"),
          EventBenifits.init(title: "추석 연휴에도 안심 이동", duration: "2020-08-09~2020-10-10", info: "스카차-브라이트 살균 소독 티슈 배치"),
          EventBenifits.init(title: "쏘카타고 도미토 픽업", duration: "2020-09-01~2020-09-31", info: "도미도피자 30% 할인!"),
          EventBenifits.init(title: "네이버페이 결제 이벤트", duration: "2020-08-01~2020-09-28", info: "Npay 최대 9,000원 할인"),
          EventBenifits.init(title: "티웨이 할인 쿠폰 이벤트", duration: "2020-08-01~2020-09-28", info: "오직 쏘카에서만 티웨이 특가"),
          EventBenifits.init(title: "초소형 전기차", duration: "2020-08-01~2020-09-28", info: "쏘카에서 만나는 새로운 모빌리티"),
          EventBenifits.init(title: "쏘카 페어링", duration: "2020-08-01~2020-09-28", info: "미리 준비하는 추석"),
          EventBenifits.init(title: "쏘카 이용 족집게 가이드", duration: "2020-08-01~2020-09-28", info: "더 똑똑하게 이용하는 방법"),
          EventBenifits.init(title: "제주에서 만나는 이동의 미래", duration: "쏘카 자율주행 셔틀 운행!", info: "쏘카 스테이션 제주에서 만나보세요"),
          EventBenifits.init(title: "개인 업무용 예약 이벤트", duration: "2020-08-01~2020-09-28", info: "쏘카패스 무료 체험권 받기"),
          EventBenifits.init(title: "쏘카 인스타그램 이벤트", duration: "2020-08-01~2020-09-28", info: "팔로우하고 일상을 파랗게 채우세요!")
        ]
        
        eventAndBenefitsVC.eventAndBenefitsArray = eventArray
        let navicontroller = UINavigationController(rootViewController: eventAndBenefitsVC)
        navicontroller.modalPresentationStyle = .overFullScreen
        mainVC.present(navicontroller, animated: true, completion: nil)
      }
    case .couponCell, .customerCenterCell, .eventBannerCell:
      break
    case .mainBoardCell, .socarPassCell, .socarPlusCell, .inviteFriendCell:
      break
    }
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    isVerticalStcolling = false
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    isVerticalStcolling = true
  }
}
// MARK: - button Action
extension SideBarVC {
  @objc func tapButtomViewButton(_ sender: UIButton) {
    switch sender {
    case sideBarBottonView.businessButton:
      print("sideBarBottonView.businessButton")
    case sideBarBottonView.planButton:
      print("sideBarBottonView.planButton")
    case sideBarBottonView.pairingButton:
      print("sideBarBottonView.pairingButton")
    default:
      return
    }
  }
  
  @objc func tapHaederButton(_ sender: UIButton) {
    guard let navi = self.presentingViewController as? UINavigationController else { return }
    guard let mainVC = navi.viewControllers.last as? MainVC else { return }
    
    switch sender {
    case tableHeaderView.socarClubButton:
      dismissWithAnimated {
        let socarClubVC = SocarClubVC()
        let navicontroller = UINavigationController(rootViewController: socarClubVC)
        navicontroller.modalPresentationStyle = .overFullScreen
        mainVC.present(navicontroller, animated: true, completion: nil)
      }
    case tableHeaderView.settingButton:
      print("tableHeaderView.tapHaederButton")
      dismissWithAnimated {
        let userDetailVC = UserDetailVC()
        mainVC.navigationController?.pushViewController(userDetailVC, animated: true)
      }
    case tableHeaderView.notiButton:
      print("tableHeaderView.notiButton")
    default:
      return
    }
  }
}

// MARK: - TableView PnaGuresture Recognizer
extension SideBarVC {

  @objc private func dragTableView(_ sender: UIPanGestureRecognizer) {
    guard isVerticalStcolling == false else { return }
    let touchPoint = sender.location(in: view)
    
    if sender.state == .began {
      isHorizenScrolling = true
      gapX = touchPoint.x - tableView.center.x
      tableViewOriginX = tableView.center.x
      firstTouchOriginX = touchPoint.x
    } else if sender.state == .changed {
      guard firstTouchOriginX > touchPoint.x else { return }
      let viewBackGroundColorRatio = min(touchPoint.x/UIScreen.main.bounds.width, 0.5)
      self.view.backgroundColor = UIColor.black.withAlphaComponent(viewBackGroundColorRatio)
      tableView.center.x = touchPoint.x - gapX
    } else if sender.state == .ended {
      isHorizenScrolling = false
      if touchPoint.x < UIScreen.main.bounds.width*(1-viewWidthSizeRatio) {
        dismissWithAnimated(completion: nil)
      } else {
        UIView.animate(withDuration: 0.2) {
          self.tableView.center.x = self.tableViewOriginX
        }
      }
    }
  }
}