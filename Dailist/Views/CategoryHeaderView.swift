//
//  CategoryHeaderView.swift
//  Dailist
//
//  Created by 안지희 on 3/18/25.
//

import UIKit

class CategoryHeaderView:UIView{
    
    //카테고리 라벨
    var categoryLabel:UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .red
        return label
    }() //왜붙이지?
    
    //추가버튼
    var addButton : UIButton = {
        let button = UIButton(type: .system)
        //시스템 + 버튼 사용
        button.setImage(UIImage(systemName: "plus"), for:.normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    //categoryName 프로퍼티 (카테고리명 설정)
    //이게뭐지
    //카테고리명을 변경하면 바로 UI에 반영
    var categoryName:String = ""{
        didSet{
            categoryLabel.text = categoryName
        }
    }
    
    //클로저 활용 -> 클로저가 뭐지?
    //버튼이 눌렀을 때 실행될 클로저를 저장 클로저 약간 함수비슷한거?
    var addButtonTapped: (() -> Void)?
    
    
    
    //UIView를 초기화하는 생성자
    //setupUI가 UI 초기설정함수임
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    //이건 스토리보드 사용시 필요 여기선 사용x
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        self.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.layer.cornerRadius = 20
        
        //스택뷰 -> 카테고리 라벨과 버튼을 수평
        let stackView = UIStackView(arrangedSubviews: [categoryLabel,addButton])
        stackView.axis = .horizontal
        stackView.spacing = 4 //스택뷰 크기
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //버튼의 위치 설정
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),

            //버튼의 크기 설정
            addButton.widthAnchor.constraint(equalToConstant: 30), //가로
            addButton.heightAnchor.constraint(equalToConstant: 30) //세로
        ])
        
        addButton.addTarget(self, action: #selector(addButtonAction), for: . touchUpInside)
    }
    
    
    @objc private func addButtonAction(){
        addButtonTapped?()
    }
    
}



//프리뷰
#if DEBUG
import SwiftUI

struct CategoryHeaderViewPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> CategoryHeaderView {
        let view = CategoryHeaderView()
        view.categoryName = "공부"
        view.addButtonTapped = { print("추가 버튼 클릭됨") }
        return view
    }

    func updateUIView(_ uiView: CategoryHeaderView, context: Context) {}
}

struct CategoryHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHeaderViewPreview()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
