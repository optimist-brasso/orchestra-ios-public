//
//  EditProfileController.swift
//  Orchestra
//
//  Created by manjil on 04/04/2022.
//

import UIKit
import Combine

enum PickerType {
    case year
    case month
    case day
    case pro
}

class EditProfileController: BaseController {
    
    private var screen: EditProfileScreen {
        baseScreen as! EditProfileScreen
    }
    
    private var presenter: EditProfilePresenter {
        basePresenter as! EditProfilePresenter
    }
    
    let cameraHandler = CameraHandler()
    
    var showBackbutton = false
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        var components = DateComponents()
        components.setValue(-100, for: Calendar.Component.year)
        let date = Date()
        let minDate = Calendar.current.date(byAdding: components, to: date)
        picker.minimumDate = minDate
        picker.maximumDate = date
        picker.addTarget(self, action: #selector(actionDate(_:)), for: .valueChanged)
        return picker
    }()
    
    private lazy var proPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        [screen.yearText,
         screen.monthText,
         screen.dayText].forEach({
            $0.inputView = datePicker
        })
        screen.occupationName.textfield.inputView = proPicker
        
        proPicker.delegate = self
        proPicker.dataSource = self
        
        screen.selected = presenter.selected
        
        screen.occupationName.textfield.attributedPlaceholder = presenter.pro.first?.title.placeholder
        set(date: Date(), isPlaceHolder: true)
        if let date = presenter.age.value.toDate(format: .dashYYYYMMDD) {
            set(date: date, isPlaceHolder: false)
            datePicker.date = date
        }
        screen.selected = presenter.selected
        if let index = presenter.pro.firstIndex(where: { $0.id == self.presenter.selectedOccupation })  {
            proPicker.selectRow(index, inComponent: 0, animated: false)
        }
        
        screen.selfIntroductionText.placeholder.isHidden = !presenter.selfIntroduction.value.isEmpty
        let email = presenter.profile?.email ?? ""
        
        screen.emailAddress.isHidden = email.isEmpty
        screen.emailAddress.textfield.text = email
        if presenter.profile != nil {
            screen.title.isHidden = true
            screen.uploadIconButton.setAttributedTitle(LocalizedKey.changeThePhoto.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14)]), for: .normal)
            screen.toRegisterButton.setAttributedTitle(LocalizedKey.updateProfile.value.attributeText(attribute: [.font: UIFont.notoSansJPMedium(size: .size16)]), for: .normal)
            screen.image.showImage(with: presenter.profile?.image, placeholderImage: .profilePlaceholder)
            screen.removeImageButton.isHidden = presenter.profile?.image?.isEmpty ?? true
//            navigationItem.leadingTitle = LocalizedKey.myPage.value
        }
        
        //cancel button to be hidden only when the module is itself root view controller (i.e. when profileStatus is false)
        let isFirstViewControllerInStack = navigationController?.viewControllers.count == 1 && presentingViewController == nil
        (screen as CancelScreen).cancelButton.setAttributedTitle(LocalizedKey.cancel.value.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size16), .foregroundColor: UIColor.white]), for: .normal)
        (screen as CancelScreen).cancelButton.isHidden = isFirstViewControllerInStack
        if showBackbutton {
            let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backTapped))
            navigationItem.leftBarButtonItems = [backButtonItem]
            
        }
        if isFirstViewControllerInStack {
            screen.scroll.bottomAnchor.constraint(equalTo: screen.bottomAnchor).isActive = true
        }
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }

    
    override func observerScreen() {
        screen.removeImageButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let self = self else { return }
            self.alertWithOkCancel(message: LocalizedKey.removeImageWarning.value, title: nil, style: .alert, okTitle: LocalizedKey.ok.value, okStyle: .destructive, cancelTitle: LocalizedKey.cancel.value, cancelStyle: .cancel, okAction: { [weak self] in
                if self?.presenter.profile?.image?.isEmpty ?? true {
                    self?.screen.image.image = .profilePlaceholder
                    self?.screen.removeImageButton.isHidden = true
                    return
                }
                self?.showLoading()
                self?.presenter.deleteProfileImage()
            }, cancelAction: nil)
        }.store(in: &presenter.bag)
        
        screen.toRegisterButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let self = self else { return }
            self.view.endEditing(true)
            self.validate()
        }.store(in: &presenter.bag)
        
        screen.uploadIconButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let self = self else { return }
            self.openImageController()
        }.store(in: &presenter.bag)
        
        screen.yearText.publisher(for: .editingDidEnd).receive(on: RunLoop.main).sink { [weak self]  _ in
            guard let self = self else { return }
            if (self.screen.yearText.text ?? "").isEmpty {
                self.set(date: Date())
            }
        }.store(in: &presenter.bag)
        
        screen.monthText.publisher(for: .editingDidEnd).receive(on: RunLoop.main).sink { [weak self]  _ in
            guard let self = self else { return }
            if (self.screen.monthText.text ?? "").isEmpty {
                self.set(date: Date())
            }
        }.store(in: &presenter.bag)
        
        screen.dayText.publisher(for: .editingDidEnd).receive(on: RunLoop.main).sink { [weak self]  _ in
            guard let self = self else { return }
            if (self.screen.dayText.text ?? "").isEmpty {
                self.set(date: Date())
            }
        }.store(in: &presenter.bag)
        
        screen.dayText.publisher(for: .editingDidEnd).receive(on: RunLoop.main).sink { [weak self]  _ in
            guard let self = self else { return }
            if (self.screen.dayText.text ?? "").isEmpty {
                self.set(date: Date())
            }
        }.store(in: &presenter.bag)
        
        screen.occupationName.textfield.publisher(for: .editingDidEnd).receive(on: RunLoop.main).sink { [weak self]  _ in
            guard let self = self else { return }
            if (self.screen.occupationName.textfield.text ?? "").isEmpty && !self.presenter.pro.isEmpty {
                self.set(row: 0)
            }
        }.store(in: &presenter.bag)
    }
    
    override func observeEvents() {
        presenter.response.sink { [weak self] response in
            guard let self = self else { return }
            self.hideLoading()
            self.alert(title: "", msg: response.0, actions: [AlertConstant.ok]) { [weak self] _ in
                guard let self = self else { return }
                if response.1 {
                    if self.presenter.profile != nil {
                        self.cancelAction(self.screen.cancelButton)
                    } else {
                        self.showLoading()
                        self.presenter.login()
                        //                        self.presenter.trigger.send(.homePage)
                    }
                }
            }
        }.store(in: &presenter.bag)
        presenter.imageDeleteResponse.sink { [weak self] in
            self?.hideLoading()
            self?.screen.removeImageButton.isHidden = true
            self?.screen.image.image = .profilePlaceholder
        }.store(in: &presenter.bag)
    }
    
    override func bindUI() {
        (screen.fullName.textfield<->presenter.fullName).store(in: &presenter.bag)
        (screen.otherGenderText<->presenter.otherGender).store(in: &presenter.bag)
        (screen.nickName.textfield<->presenter.nickName).store(in: &presenter.bag)
        (screen.instrumentName.textfield<->presenter.instrument).store(in: &presenter.bag)
        (screen.postal.textfield<->presenter.postalcode).store(in: &presenter.bag)
        (screen.occupationName.textfield<->presenter.occupation).store(in: &presenter.bag)
        (screen.selfIntroductionText<->presenter.selfIntroduction).store(in: &presenter.bag)
    }
    
}


extension EditProfileController {
    
    private func validate() {
        presenter.selected = screen.selected
        if presenter.profile != nil {
            validateAndUpdate()
            return
        }
        //        guard let data = screen.image.image?.jpegData(compressionQuality: 1),
        //              screen.image.image != .profilePlaceholder else {
        //            alert(title: "", msg: LocalizedKey.selectProfileImage.value, actions: [AlertConstant.ok])
        //            return
        //        }
        if case .addOther = presenter.selected,
           (screen.otherGenderText.text ?? "").isEmpty {
            alert(title: "", msg: LocalizedKey.genderRequired.value, actions: [AlertConstant.ok])
            return
        }
        if let error = presenter.error.first {
            alert(title: "", msg: error.localizedDescription, actions: [AlertConstant.ok])
            return
        }
        showLoading()
        if let data = screen.image.image?.jpegData(compressionQuality: 1),
           screen.image.image != .profilePlaceholder {
            let value = presenter.configApp?.profileImageSize ?? "2048"
            let neededSize = (Int(value) ?? .zero) * 1024
            if data.count > neededSize {
                hideLoading()
                alert(title: "", msg: LocalizedKey.errorImageSize("\(value)").value, actions: [AlertConstant.ok])
                return
            }
            //presenter.upload(image: data, additionalParams: presenter.param())
            presenter.upload(image: data)
        } else {
            presenter.upload(image: nil)
        }
    }
    
    private func validateAndUpdate() {
        if case .addOther = presenter.selected,
           (screen.otherGenderText.text ?? "").isEmpty {
            alert(title: "", msg: LocalizedKey.genderRequired.value, actions: [AlertConstant.ok])
            return
        }
        if let error = presenter.error.first {
            alert(title: "", msg: error.localizedDescription, actions: [AlertConstant.ok])
            return
        }
        showLoading()
        presenter.updateProfile()
    }
    
    @objc private func actionDate(_ sender: UIDatePicker) {
        set(date: sender.date)
    }
    
    private func set(date: Date, isPlaceHolder: Bool = false) {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        if isPlaceHolder {
            if let year = component.year {
                screen.yearText.attributedPlaceholder = "\(year)".placeholder
            }
            if let month = component.month {
                screen.monthText.attributedPlaceholder =  "\(month)".placeholder
            }
            if let day = component.day {
                screen.dayText.attributedPlaceholder =  "\(day)".placeholder
            }
            return
        }
        if let year = component.year {
            screen.yearText.text = "\(year)"
        }
        if let month = component.month {
            screen.monthText.text =  "\(month)"
        }
        if let day = component.day {
            screen.dayText.text =  "\(day)"
        }
        presenter.age.value = date.toString(format: .dashYYYYMMDD)
    }
    
}

//MARK: UIPickerViewDelegate & UIPickerViewDataSource
extension EditProfileController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        presenter.pro.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        presenter.pro.element(at: row)?.title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        set(row: row)
    }
    
    private func set(row: Int) {
        if let pro = presenter.pro.element(at: row) {
            presenter.selectedOccupation = pro.id
            presenter.occupation.value = pro.title
        }
    }
    
}

extension EditProfileController {
    
    private func openImageController() {
        let screen = ProfileImagePickScreen()
        let controller = ProfileImagePickController(screen: screen, presenter: BasePresenter())
        controller.imagePickedBlock = { [weak self] image in
            guard let self = self else { return }
            self.screen.image.image = image
            self.screen.removeImageButton.isHidden = false
//            self.screen.removeImageButton.isHidden = self.presenter.profile == nil
        }
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        controller.canUpload = presenter.profile != nil
        present(controller, animated: true)
    }
    
}
