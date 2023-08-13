//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit
import RxCocoa
import RxSwift

final class AgreementViewController: UIViewController {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var termsButton: UIButton!
    @IBOutlet private weak var privacyButton: UIButton!
    @IBOutlet private weak var agreementButton: UIButton!

    private let disposeBag = DisposeBag()

    var viewModel: AgreementViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureText()
        configureDefaults()
        configureImageView()
        configureButton()
        binding()
    }
}

// MARK: Binding
private extension AgreementViewController {
    func binding() {
        termsButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapTermsButton.accept(())
            }
            .disposed(by: disposeBag)

        privacyButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapPrivacyButton.accept(())
            }
            .disposed(by: disposeBag)

        agreementButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapAgreementButton.accept(())
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension AgreementViewController {
    func configureText() {
        //        let filePath = R.file
        //        textView.attributedText = Common.loadRtfFileContents(filePath)
    }

    func configureDefaults() {
        textView.layer.cornerRadius = 10.0
        view.backgroundColor = .white
    }

    func configureImageView() {
        iconImageView.image = UIImage(resource: R.image.tokumemoPlusIcon)
        iconImageView.layer.cornerRadius = 50.0
    }

    func configureButton() {
        agreementButton.setTitle(R.string.localizable.agree(), for: .normal)
        agreementButton.backgroundColor = UIColor(resource: R.color.subColor)
        agreementButton.tintColor = .black
        agreementButton.layer.cornerRadius = 5.0
        agreementButton.layer.borderWidth = 1

        termsButton.setTitle(R.string.localizable.terms_of_service(), for: .normal)
        termsButton.backgroundColor = .white
        termsButton.borderColor = .black
        termsButton.tintColor = .black
        termsButton.layer.cornerRadius = 10.0
        termsButton.layer.borderWidth = 1

        privacyButton.setTitle(R.string.localizable.privacy_policy(), for: .normal)
        privacyButton.backgroundColor = .white
        privacyButton.borderColor = .black
        privacyButton.tintColor = .black
        privacyButton.layer.cornerRadius = 10.0
        privacyButton.layer.borderWidth = 1
    }
}
