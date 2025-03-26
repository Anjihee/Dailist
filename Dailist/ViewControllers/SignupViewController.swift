//
//  SignupViewController.swift
//  Dailist
//
//  Created by 안지희 on 3/18/25.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {
    
    //이건 왜 override라고 하지?
    //다른 함수는 보통 private라고 쓰던데 왜지?
    //기본으로 override라고 쓰길래 왜지 싶어서 흠..
    override func viewDidLoad () {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        //다시 입력하면 에러 메세지 자동 제거
        //이부분
        confrimpasswordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        //회원가입시 버튼
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
    }
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력해주세요"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 15 // 🔥 모서리를 둥글게
        return textField
    }()
    
    //클로저로 UI 선언
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력해주세요"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 15 // 🔥 모서리를 둥글게
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 1
        return textField
    }()
    
    private let confrimpasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 확인해주세요"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 1
        return textField
    }()


    //비밀번호 일치 하지 않을시
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true //처음에는 보이지 않게 하기 위함
        
        return label
    }()

    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal) 
        button.backgroundColor = .black
        return button
    }()
    

    //UI 총 배치
    private func setupUI(){
        let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField, confrimpasswordTextField,errorLabel,signupButton])
        
        stackView.axis = .vertical
        stackView.spacing = 30
        //여기서 alignment가 어떤 기능이지?
        stackView.alignment = .fill
        // Auto Layout을 사용하려면 이걸 false로 설정해야 함
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
        //개별 필드 높이 조절
        NSLayoutConstraint.activate([
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            confrimpasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            signupButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    //메서드
    //이메일 인증 기능
    //회원가입 버튼
    @objc private func handleSignup(){
        //guard -> 안전하게 옵셔널 풀기
        //if else와 비슷하다 값이 있으면 넣고 없으면 지나가
        //각 입력값 넣기
        
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confrimPassword = confrimpasswordTextField.text else{
            return
        }
        
        //비밀번호 일치 체크 -> 불일치시 에러메세지
        guard password == confrimPassword else {
            errorLabel.text = "비밀번호가 일치하지 않습니다."
            errorLabel.isHidden = false
            return
        }
        
        //파이어베이스 회원가입
        Auth.auth().createUser(withEmail : email, password: password){ [weak self] authResult, error in
            if let error = error{
                self?.errorLabel.text = "회원가입 실패: \(error.localizedDescription)"
                self?.errorLabel.isHidden = false
                return
            }
            
            authResult?.user.sendEmailVerification(completion: { error in
                if let error = error {
                    self?.errorLabel.text = "인증 이메일 전송 실패: \(error.localizedDescription)"
                    self?.errorLabel.isHidden = false
                    return
                }
                
                let alert = UIAlertController(
                           title: "이메일 인증",
                           message: "입력하신 이메일로 인증 링크가 전송되었습니다.\n이메일을 확인한 후 아래 버튼을 눌러주세요.",
                           preferredStyle: .alert
                       )
                
                       alert.addAction(UIAlertAction(title: "인증 확인", style: .default, handler: { _ in
                           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                               Auth.auth().currentUser?.reload(completion: { error in
                                   if let error = error {
                                    self?.errorLabel.text = "유저 정보 갱신 실패: \(error.localizedDescription)"
                                    self?.errorLabel.isHidden = false
                                    return
                                }
                                
                        //회원가입 + 이메일 인증 완료
                        if Auth.auth().currentUser?.isEmailVerified == true {
                            
                       //회원가입한 현재 유저를 Firebase Store에 저장
                        //근데 currentUser라는건 어떤 의미지? uid는?
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        let db = Firestore.firestore()
                        
                        let userDate : [String:Any] = [
                            "name" : name,
                            "email" : email,
                            "createAt":FieldValue.serverTimestamp()
                        ]
                                
                                    
                        //파베 Store에 users라는 테이블이 생성됨
                        db.collection("users").document(uid).setData(userDate){ error in
                                if let error = error {
                                    print("❌ Firestore 저장 실패: \(error.localizedDescription)")
                                } else {
                                    print("✅ Firestore 저장 완료")
                                        // 로그인 화면으로 이동
                                    self?.navigationController?.popViewController(animated: true)
                                }
                            }} else {
                                // 인증 안 됨 → 안내 알림
                                let notVerifiedAlert = UIAlertController(
                                title: "아직 인증되지 않았습니다",
                                message: "메일 속 링크를 클릭했는지 확인해주세요.",
                                preferredStyle: .alert
                                )
                                notVerifiedAlert.addAction(UIAlertAction(title: "확인", style: .cancel))
                                self?.present(notVerifiedAlert, animated: true)
                            }
                        })}
                    }))
                //이거 왜하는건데?
                self?.present(alert, animated: true)
            })
        }
    }
    
    
    //에러메세지 자동 제거
    @objc private func textDidChange(){
        errorLabel.isHidden = true
    }    
}


#if DEBUG
import SwiftUI

struct SignupViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SignupViewController {
        return SignupViewController()
    }
    
    func updateUIViewController(_ uiViewController: SignupViewController, context: Context) {}
}

struct SignupViewController_Previews: PreviewProvider {
    static var previews: some View {
        SignupViewControllerPreview()
    }
}
#endif
