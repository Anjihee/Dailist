//
//  SignupViewController.swift
//  Dailist
//
//  Created by 안지희 on 3/18/25.
//


import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    //클로저로 UI 선언
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력해주세요"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let confrimpasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 확인해주세요"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("눈", for: .normal)
        button.addTarget(self, action: #selector(handleTogglePassword), for: .touchUpInside)
        return button
    }()
    
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleTogglePassword(){
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc private func handleSignup(){
        let stackView = UIStackView()
        stackView
    }
    
    private func setupUI(){
        
    }
    
    
}
