//
//  StatusSwitcher.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 2/1/24.
//

import UIKit

class StatusSwitcher: UIView, UIGestureRecognizerDelegate {

    var viewOne = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var viewTwo = UILabel(frame: CGRect(x: 50, y: 0, width: 50, height: 50))
    var viewThree = UILabel(frame: CGRect(x: 50, y: 0, width: 50, height: 50))
    weak var delegate : StatusPickerDelegate?

    var toDoTask : ToDoTask?{
        didSet{
            if let task = toDoTask?.taskStatus{
                cycleStatusNoAnimation(task)
            }
        }
    }
    private var initialCenter: CGPoint = .zero

    var stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 300, height: 36))
    var panGestureRecognizer: UIPanGestureRecognizer?
    var tapGestureRecognizer: UITapGestureRecognizer?
    var status: ToDoTaskStatus

    init(frame: CGRect,_ status: ToDoTaskStatus) {
        self.status = status
        super.init(frame: frame)

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGestureRecognizer?.delegate = self
        
        if status == .inProgress{
            stack = UIStackView(frame: CGRect(x: -100, y: 0, width: 300, height: 36))
        }else if status == .done{
            stack = UIStackView(frame: CGRect(x: -200, y: 0, width: 300, height: 36))
        }
        self.layer.cornerRadius = 10

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
        viewOne.textAlignment = .center
        NSLayoutConstraint.activate([
            viewOne.widthAnchor.constraint(equalToConstant: 100),
            viewOne.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        viewTwo.translatesAutoresizingMaskIntoConstraints = false
        viewTwo.backgroundColor = .purple
        viewTwo.text = "In Progress"
        viewTwo.textColor = .white
        viewTwo.textAlignment = .center

        viewThree.translatesAutoresizingMaskIntoConstraints = false
        viewThree.backgroundColor = .blue
        viewThree.text = "Done"
        viewThree.textColor = .white
        viewThree.textAlignment = .center

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

        stack.clipsToBounds = true
        stack.axis = .horizontal

        self.clipsToBounds = true
        stack.layer.masksToBounds = true
        self.addSubview(stack)
        stack.frame.origin = CGPoint(x: 0, y: 0)
                
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

    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        
        guard let task = toDoTask else {return}
        switch sender.state {
        case .began:
            initialCenter = stack.center
            
        case .changed:
            let translation = sender.translation(in: self)

            stack.center = CGPoint(x: initialCenter.x + translation.x,
                                          y: initialCenter.y )

            if translation.x < -24{
                panGestureRecognizer?.isEnabled = false

                if status == .ready{
                    status = .inProgress
                    cycleStatus(task,status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)

                }else if status == .inProgress{
                    status = .done
                    cycleStatus(task,status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false
                }
                else if status == .done{
                    status = .done
                    cycleStatus(task,status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false
                }
            }else if translation.x > 24{
                panGestureRecognizer?.isEnabled = false

                if status == .done{
                    status = .inProgress
                    cycleStatus(task,status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false
                    
                }else if status == .inProgress{
                    status = .ready
                    cycleStatus(task,status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false
                    
                }else if status == .ready{
                    status = .ready
                    cycleStatus(task,status)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    panGestureRecognizer?.isEnabled = false
                    
                }
            }
        case .ended:
            panGestureRecognizer?.isEnabled = false
            cycleStatus(task,status)
            gestureRecognizerIsPannable()
            
        default:
            break
        }
    }
    
    var timer = Timer()
    
    func gestureRecognizerIsPannable(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            self.panGestureRecognizer?.isEnabled = true

        }

    }
    func cycleStatus(_ task: ToDoTask, _ status:ToDoTaskStatus){
        gestureRecognizerIsPannable()

        if status == .ready{

            UIView.animate(withDuration: 0.5) {
                self.stack.frame.origin = CGPoint(x: 0,
                                       y: 0)

            } completion: { _ in
                self.delegate?.changeStatusFor(task, self.status)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    //print("Timer fired!")
                    self.self.panGestureRecognizer?.isEnabled = true

                }

            }
        }else if status == .inProgress{

            UIView.animate(withDuration: 0.7) {
                self.stack.frame.origin = CGPoint(x: -100,
                                       y: 0)

            } completion: { _ in
                self.delegate?.changeStatusFor(task, self.status)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                    self.panGestureRecognizer?.isEnabled = true

                }

            }


        }else if status == .done{

            UIView.animate(withDuration: 0.7) {
                self.stack.frame.origin = CGPoint(x: -200,
                                       y: 0)

            } completion: { _ in
                self.delegate?.changeStatusFor(task, self.status)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                   // print("Timer fired!")
                    self.self.panGestureRecognizer?.isEnabled = true

                }


            }
        }
        
    }
    
    func cycleStatusNoAnimation(_ status: ToDoTaskStatus){
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
}
