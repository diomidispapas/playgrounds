//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol ContainingViewController: class {
    var activeViewController: UIViewController? { get set }
    func removeInactiveViewController(_ viewController: UIViewController)
    func updateActiveViewController(_ viewController: UIViewController)
}

private var containingViewControllerAssociationKey: UInt8 = 0
extension ContainingViewController where Self: UIViewController {
    
    var activeViewController: UIViewController? {
        set {
            if let activeViewController = activeViewController {
                removeInactiveViewController(activeViewController)
            }
            
            if let newActiveViewController = newValue {
                updateActiveViewController(newActiveViewController)
            }
            
            objc_setAssociatedObject(self, &containingViewControllerAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &containingViewControllerAssociationKey) as? UIViewController
        }
    }
    
    func removeInactiveViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func updateActiveViewController(_ viewController: UIViewController) {
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        containingViewControllerChanged()
    }
    
    private func containingViewControllerChanged() {
        setNeedsStatusBarAppearanceUpdate()
    }
}

// Example

final class ColorsViewController : UIViewController, ContainingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        activeViewController = ColorViewController(color: .random)

        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] (timer) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.activeViewController = ColorViewController(color: .random)
            }
        }
    }
}

final class ColorViewController : UIViewController {
    
    init(color: UIColor) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = color
    }
    
    required public init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red:   .random,
                       green: .random,
                       blue:  .random,
                       alpha: 1.0)
    }
}

PlaygroundPage.current.liveView = ColorsViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
