//
//  AboutAppView.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/21/22.
//

import UIKit


class AboutAppView: UIView {
    
    //MARK: Properties
    weak var presenter: AboutAppModuleInterface?
    
    //MARK: UI Elements
    private lazy var topView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(hexString: "#C4C4C4").withAlphaComponent(0.4)
        
        let label = UILabel()
        label.text = LocalizedKey.aboutApp.value
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 27),
            label.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        
        return v
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    
//    private lazy var headerLabel: UILabel = {
//        let label = UILabel()
//        label.text = "簡単な概要"
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .appFont(type: .notoSansJP(.medium), size: .size15)
//        return label
//    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
演奏する人も、聴く人も。
吹奏楽の楽しみ方が180°変わるVR アプリ Brasso。

まるで、その場にいるかの様な「立体音響（スペシャルオーディオ）」と「VR 映像」を楽しむなら、
＜Conductor（コンダクター）＞か、＜Session（セッション）＞で。
Conductor は、指揮者になった気分が...Session では、奏者になった気分が存分に味わえます。また、VR ゴーグルを装着すれば、更なる没入感が得られ、まるでステージの上に立っているかの様な体験ができます。

本格的なホールの音を楽しむなら、＜Hall Sound＞。
いろんなホールの音*1 が楽しめるだけでなく、聞いた事が無かった場所の音が聞くことができ、様々な場所 で演奏を楽しむ事ができます。（映像はありません）
*1 初期段階では1 会場・4 箇所での提供になります。

あなた自身が合奏に参加して、演奏を楽しむなら＜Session＞。
一緒のステージに立っている疑似体験ができるほか、あなた自身の演奏で、足りない音を埋めて、楽曲を完
成させる事ができます。また、録音機能*2 を使えば、あなたが合奏に参加した楽曲が完成します。
*2 今後実装予定

＜Player＞では、演奏に参加していただいたプロ奏者全員のプロフィールを閲覧することができます。

もっと詳しく知りたい方は、Brasso のホームページ（https://brasso.jp/）をご覧ください。
"""
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.font = .appFont(type: .notoSansJP(.regular), size: .size14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    private lazy var reviewRatingButton: UIButton = {
    //        let btn = UIButton()
    //        btn.setTitle(LocalizedKey.reviewRating.value, for: .normal)
    //        addSimilarProperties(to: btn)
    //        btn.addTarget(self, action: #selector(reviewButtonTapped), for: .touchUpInside)
    //        return btn
    //    }()
    
    private lazy var termServiceButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(LocalizedKey.termsOfService.value, for: .normal)
        addSimilarProperties(to: btn)
        btn.addTarget(self, action: #selector(termServiceBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var privacyPolicButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(LocalizedKey.privacyPolicy.value, for: .normal)
        addSimilarProperties(to: btn)
        btn.addTarget(self, action: #selector(privacyButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var notationButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(LocalizedKey.notation.value, for: .normal)
        addSimilarProperties(to: btn)
        btn.addTarget(self, action: #selector(notationButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var softwareLicenseButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(LocalizedKey.softwareLiscence.value, for: .normal)
        addSimilarProperties(to: btn)
        btn.addTarget(self, action: #selector(softwareLicButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //    private lazy var musicLicenseButton: UIButton = {
    //        let btn = UIButton()
    //        btn.setTitle(LocalizedKey.songLiscence.value, for: .normal)
    //        addSimilarProperties(to: btn)
    //        btn.addTarget(self, action: #selector(musicLicButtonTapped), for: .touchUpInside)
    //        return btn
    //    }()
    
    //MARK: Intialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, presenter: AboutAppModuleInterface) {
        self.init(frame: frame)
        self.presenter = presenter
        //configuration
        configureTopView()
        configureScrollView()
     //   configureHeaderLabel()
        configureDescriptionLabel()
        // configureReviewButton()
        configureTermServiceButton()
        configurePrivacyPolicyButton()
        configureNotationButton()
        configureSoftwareLicenseButton()
        //configureMusicLicenseButton()
    }
    
    //MARK: UI Configuration
    
    private func configureTopView() {
        addSubview(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 43)
        ])
    }
    
    private func configureScrollView() {
        addSubview(scrollView)
        scrollView.fillSuperView(inset: .init(top: 43, left: .zero, bottom: .zero, right: .zero))
    }
    
//    private func configureHeaderLabel() {
//        scrollView.addSubview(headerLabel)
//        headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        headerLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
//    }
    
    private func configureDescriptionLabel() {
        scrollView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
            descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20)
        ])
    }
    
    //    private func configureReviewButton() {
    //        scrollView.addSubview(reviewRatingButton)
    //        NSLayoutConstraint.activate([
    //            reviewRatingButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
    //            reviewRatingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27),
    //            reviewRatingButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
    //            reviewRatingButton.heightAnchor.constraint(equalToConstant: 50),
    //        ])
    //    }
    
    private func configureTermServiceButton() {
        scrollView.addSubview(termServiceButton)
        NSLayoutConstraint.activate([
            termServiceButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            termServiceButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
            termServiceButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            termServiceButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configurePrivacyPolicyButton() {
        scrollView.addSubview(privacyPolicButton)
        NSLayoutConstraint.activate([
            privacyPolicButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            privacyPolicButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
            privacyPolicButton.topAnchor.constraint(equalTo: termServiceButton.bottomAnchor, constant: 15),
            privacyPolicButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureNotationButton() {
        scrollView.addSubview(notationButton)
        NSLayoutConstraint.activate([
            notationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            notationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
            notationButton.topAnchor.constraint(equalTo: privacyPolicButton.bottomAnchor, constant: 15),
            notationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureSoftwareLicenseButton() {
        scrollView.addSubview(softwareLicenseButton)
        NSLayoutConstraint.activate([
            softwareLicenseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            softwareLicenseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
            softwareLicenseButton.topAnchor.constraint(equalTo: notationButton.bottomAnchor, constant: 15),
            softwareLicenseButton.heightAnchor.constraint(equalToConstant: 50),
            softwareLicenseButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30)
        ])
    }
    
    //    private func configureMusicLicenseButton() {
    //        scrollView.addSubview(musicLicenseButton)
    //        NSLayoutConstraint.activate([
    //            musicLicenseButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
    //            musicLicenseButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27),
    //            musicLicenseButton.topAnchor.constraint(equalTo: softwareLicenseButton.bottomAnchor, constant: 15),
    //            musicLicenseButton.heightAnchor.constraint(equalToConstant: 50),
    //            musicLicenseButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30)
    //        ])
    //    }
    
    //MARK: Private Methods
    private func addSimilarProperties(to btn: UIButton) {
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .appFont(type: .notoSansJP(AppFontWeight.regular), size: .size15)
    }
    
    //MARK: Objc Methods
    //    @objc private func reviewButtonTapped() {
    //        presenter?.reviewRatingButtonTapped()
    //    }
    //
    @objc private func termServiceBtnTapped() {
        presenter?.termServiceBtnTapped()
    }
    
    @objc private func privacyButtonTapped() {
        presenter?.privacyButtonTapped()
    }
    
    @objc private func notationButtonTapped() {
        presenter?.notationButtonTapped()
    }
    
    @objc private func softwareLicButtonTapped() {
        presenter?.softwareLicButtonTapped()
    }
    
    //    @objc private func musicLicButtonTapped() {
    //        presenter?.musicLicButtonTapped()
    //    }
    
}
