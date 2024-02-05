//
//  StatusSwitcher.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 2/1/24.
//

import UIKit

class StatusSwitcher: UIView, UIGestureRecognizerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    var viewOne = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
//    var viewTwo = UIView(frame: CGRect(x: 50, y: 0, width: 50, height: 20))
    var viewOne = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var viewTwo = UILabel(frame: CGRect(x: 50, y: 0, width: 50, height: 50))
    var viewThree = UILabel(frame: CGRect(x: 50, y: 0, width: 50, height: 50))
    weak var delegate : StatusPickerDelegate?

    private var initialCenter: CGPoint = .zero
    weak var taskTabledelegate : TaskTableDelegate?

    var stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 300, height: 36))
    var panGestureRecognizer : UIPanGestureRecognizer?
    var tapGestureRecognizer : UITapGestureRecognizer?
    var status : TaskStatus{
        didSet{
            //cycleStatusNoAnimation(status)
        }
    }

    init(frame: CGRect,_ status: TaskStatus) {
        self.status = status
        super.init(frame: frame)

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGestureRecognizer?.delegate = self
        
     
        if status == .inProgress{
            stack = UIStackView(frame: CGRect(x: -100, y: 0, width: 300, height: 36))

        }else if status == .done{
            stack = UIStackView(frame: CGRect(x: -200, y: 0, width: 300, height: 36))

        }

//
//        timer = Timer(timeInterval: 5.0, repeats: false, block: { _ in
//            self.gestureRecognizerIsPannable()
//        })
        
        
        initialCenter = self.center
        backgroundColor = .white
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        viewOne.translatesAutoresizingMaskIntoConstraints = false
        viewOne.backgroundColor = .green
        viewOne.text = "Ready"
        NSLayoutConstraint.activate([
            viewOne.widthAnchor.constraint(equalToConstant: 100),
            viewOne.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        viewTwo.translatesAutoresizingMaskIntoConstraints = false
        viewTwo.backgroundColor = .purple
        viewTwo.text = "In Progress"
        viewTwo.textColor = .white
        
        viewThree.translatesAutoresizingMaskIntoConstraints = false
        viewThree.backgroundColor = .blue
        viewThree.text = "Done"
        viewThree.textColor = .white
        
        NSLayoutConstraint.activate([
            viewTwo.widthAnchor.constraint(equalToConstant: 100),
            viewTwo.heightAnchor.constraint(equalToConstant: 36)
        ])
        NSLayoutConstraint.activate([
            viewThree.widthAnchor.constraint(equalToConstant: 100),
            viewThree.heightAnchor.constraint(equalToConstant: 36)
        ])

        stack.addArrangedSubview(viewOne)
        stack.addArrangedSubview(viewTwo)
        stack.addArrangedSubview(viewThree)

        stack.axis = .horizontal
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
        self.clipsToBounds = true
        stack.layer.masksToBounds = true
        self.addSubview(stack)
        stack.frame.origin = CGPoint(x: 0, y: 0)
        
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: self.topAnchor),
//            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//        ])
        
        if let g = panGestureRecognizer{
            stack.addGestureRecognizer(g)
            stack.isUserInteractionEnabled = true
        }
        if let t = tapGestureRecognizer{
            stack.addGestureRecognizer(t)
            t.cancelsTouchesInView = true
        }
        layoutIfNeeded()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
//        let velocity = gestureRecognizer.velocity(in: stack)
//        print(velocity.x)
//        return abs(velocity.x) > abs(velocity.y)
//    }
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            initialCenter = stack.center

            
        case .changed:
            let translation = sender.translation(in: self)

            stack.center = CGPoint(x: initialCenter.x + translation.x,
                                          y: initialCenter.y )

            if translation.x < -24{
                if status == .ready{
                    status = .inProgress
                    cycleStatus(status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false

                }else if status == .inProgress{
                    status = .done
                    cycleStatus(status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false
                }
                else if status == .done{
                    status = .done
                    cycleStatus(status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false
                }
            }else if translation.x > 24{
                
                if status == .done{
                    status = .inProgress
                    cycleStatus(status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false
                    
                }else if status == .inProgress{
                    status = .ready
                    cycleStatus(status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false
                    
                }else if status == .ready{
                    status = .ready
                    cycleStatus(status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false
                    
                }
            }
        case .ended:
            panGestureRecognizer?.isEnabled = false
            cycleStatus(status)
            gestureRecognizerIsPannable()
            
        default:
            break
        }
    }
    
    var timer = Timer()
    
    func gestureRecognizerIsPannable(){
        
        //panGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           // print("Timer fired!")
            self.panGestureRecognizer?.isEnabled = true

        }

    }
    func cycleStatus(_ status:TaskStatus){
        gestureRecognizerIsPannable()

        if status == .ready{
//            UIView.animate(withDuration: 0.5, delay: 0.0,usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut) {
//            UIView.animate(withDuration: 0.5) {
//
//                self.stack.frame.origin = CGPoint(x: 0,
//                                              y: 0)
//                //self.stack.frame.origin = CGPoint(x: 100,
//                                           //   y: 0)
//            }
            //UIView.animate(withDuration: 0.5, delay: 0.0,options: .curveEaseIn) {
            
            UIView.animate(withDuration: 0.5) {
                self.stack.frame.origin = CGPoint(x: 0,
                                       y: 0)

            } completion: { _ in
                self.delegate?.changeStatus(status: self.status)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //print("Timer fired!")
                    self.self.panGestureRecognizer?.isEnabled = true

                }

            }
        }else if status == .inProgress{
//            UIView.animate(withDuration: 0.) {
//                self.stack.frame.origin = CGPoint(x: -100,
//                                       y: 0)
//            }
            UIView.animate(withDuration: 0.7) {
                self.stack.frame.origin = CGPoint(x: -100,
                                       y: 0)

            } completion: { _ in
                self.delegate?.changeStatus(status: self.status)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   // print("Timer fired!")
                    self.panGestureRecognizer?.isEnabled = true

                }

            }


        }else if status == .done{
//            UIView.animate(withDuration: 0.5) {
//                self.stack.frame.origin = CGPoint(x: -200,
//                                       y: 0)
//            }
            UIView.animate(withDuration: 0.7) {
                self.stack.frame.origin = CGPoint(x: -200,
                                       y: 0)

            } completion: { _ in
                self.delegate?.changeStatus(status: self.status)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   // print("Timer fired!")
                    self.self.panGestureRecognizer?.isEnabled = true

                }


            }
        }
        //delegate?.changeStatus(status: self.status)
        
    }
    
    func cycleStatusNoAnimation(_ status: TaskStatus){
        if status == .ready{
                self.stack.frame.origin = CGPoint(x: 0,
                                              y: 0)
        }else if status == .inProgress{
                self.stack.frame.origin = CGPoint(x: -100,
                                          y: 0)
        }else if status == .done{

                self.stack.frame.origin = CGPoint(x: -200,
                                       y: 0)
        }

    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//
//    }
}
