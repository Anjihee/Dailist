//
//  LoginViewController.swift
//  Dailist
//
//  Created by 안지희 on 3/18/25.
//



import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //클로저 안에 해당 addTarget함수를 쓰면 안된다!! 로그인 버튼이 눌리지 않는 이슈 해결
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        goSignupButton.addTarget(self, action: #selector(goToSignup), for: .touchUpInside)
    }
    
    //클로저로 UI 선언
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력해주세요"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 15 //모서리 라운드 처리
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    private let goSignupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입 하시겠습니까?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        return button
    }()
    

    
    
    private func setupUI(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,loginButton, goSignupButton])
        
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
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // 회원가입 페이지로 이동
    @objc private func goToSignup() {
        //이거 근데 왜  ~VC로 설정하는거야?
        let signupVC = SignupViewController()
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    //로그인 버튼
    @objc private func handleLogin() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            print("❌ 이메일 또는 비밀번호가 비어 있음")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("❌ 로그인 실패: \(error)")
                let alert = UIAlertController(title: "로그인 실패", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
                return
            }

            guard let user = authResult?.user else {
                print("❌ 로그인은 되었으나 user가 nil")
                return
            }

            print(" 로그인 성공: \(user.email ?? "no email")")

            user.reload { error in
                if let error = error {
                    print("❌ 유저 정보 갱신 실패: \(error)")
                    return
                }

                if user.isEmailVerified {
                    print("이메일 인증 완료")
                    //let homeVC = MainTabBarController()
                    //self?.navigationController?.pushViewController(homeVC, animated: true
                    //에서 아래 코드로 교체한 이유 MainTabBarController를 pushViewController()로 띄웠기 때문에, 탭바 위에 불필요한 내비게이션 바(title bar)가 생긴 거야.
                    //그니까 로그인 성공시 네비게이션으로이동하면 back 버튼이 생기면서 로그인 화면 아래의 화면이 탭바가 된다 그니까 로그인 화면 자체의 상단바가 적용되니까 위에 공백이 생기는 것이다 그러니까 아예 로그인 성공시 루트 컨트롤러를 탭뷰로 바꿔주면 이런 이슈를 없앨 수있다
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let sceneDelegate = scene.delegate as? SceneDelegate {

                        let mainTab = MainTabBarController()
                        sceneDelegate.window?.rootViewController = mainTab
                        sceneDelegate.window?.makeKeyAndVisible()
                    }
                } else {
                    print("이메일 인증 안 됨")
                    let alert = UIAlertController(title: "이메일 인증 필요", message: "가입 시 전송된 인증 메일을 확인해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}

#if DEBUG
import SwiftUI

struct LoginViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LoginViewController {
        return LoginViewController()
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {}
}

struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewControllerPreview()
    }
}
#endif
