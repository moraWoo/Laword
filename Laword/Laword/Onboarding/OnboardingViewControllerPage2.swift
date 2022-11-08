//
//  OnboardingViewController.swift
//  Laword
//
//  Created by Ildar Khabibullin on 04.11.2022.
//

import UIKit

class OnboardingViewControllerPage2: UIViewController {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        let profile = UIImage(named: "imageOB2")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = profile
        return imageView
    }()

    let descriptionTextView: UITextView = {
        let message =
        """
        \n\nМетодика для запоминания информации была разработана польским студентом Петром Возняком
        в 1985 по системе Себастьяна Лейтнера.

        Основано на кривой забывания.

        Пройденные слова будут показываться вам в будущем через определенные интервалы в зависимости от вашего выбора.
        """

        let textView = UITextView()
        var titleFont: CGFloat = 0
        var descriptionFont: CGFloat = 0

        if screenHeight < 740 {
            titleFont = 18
            descriptionFont = 12
        } else {
            titleFont = 25
            descriptionFont = 18
        }

        let attributedText = NSMutableAttributedString(
            string: "Метод SuperMemo",
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: titleFont)]
        )

        attributedText.append(NSAttributedString(
            string: message,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: descriptionFont),
                         NSAttributedString.Key.foregroundColor: UIColor.gray])
        )

        textView.attributedText = attributedText
        textView.backgroundColor = UIColor.white
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(descriptionTextView)
        view.backgroundColor = UIColor.white
        setupLayout()
    }

    private func setupLayout() {
        let topImageContainerView = UIView()
        view.addSubview(topImageContainerView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false

        if screenHeight < 740 {
            topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64).isActive = true
            topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64).isActive = true
            topImageContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        } else {
            topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            topImageContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }

        topImageContainerView.addSubview(profileImageView)

        profileImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true

        if screenHeight < 740 {
            profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        } else {
            profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }

        descriptionTextView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}
