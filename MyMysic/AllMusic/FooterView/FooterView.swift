//
//  FooterView.swift
//  MyMysic
//
//  Created by Anna Nosyk on 22/07/2022.
//

import UIKit

class FooterView: UIView {
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.6319127679, green: 0.6468527317, blue: 0.664311111, alpha: 1)
       return label
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }
    
    
    private func setupElements() {
        addSubview(label)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8)
        ])
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        label.text = "LOADING"
    }
    
    
    func hideaAtivityIndicatorr() {
        activityIndicator.stopAnimating()
        label.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
