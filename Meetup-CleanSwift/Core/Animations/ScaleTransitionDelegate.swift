//
//  ScaleTransitionDelegate.swift
//  Meetup-CleanSwift
//
//  Created by Alejandro Orozco Builes on 11/12/18.
//  Copyright © 2018 Alejandro Orozco Builes. All rights reserved.
//

import UIKit

protocol Scaling {
  func scalingContainerView(transition: ScaleTransitionDelegate) -> UIView?
  func scalingImageView(transition: ScaleTransitionDelegate) -> UIImageView?
  func scalingUILabel(transition: ScaleTransitionDelegate) -> UILabel?
}

enum TransitionState {
  case begin
  case end
}

class ScaleTransitionDelegate: NSObject {
  let animationDuration = 0.5
  var navigationControllerOperation: UINavigationController.Operation = .none
}

extension ScaleTransitionDelegate: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    
    guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
    guard let toVC = transitionContext.viewController(forKey: .to) else { return }
    
    var backgroundVC = fromVC
    var foregroundVC = toVC
    
    if navigationControllerOperation == .pop {
      backgroundVC = toVC
      foregroundVC = fromVC
    }
    
    guard let backgroundImageView = (backgroundVC as? Scaling)?.scalingImageView(transition: self) else { return }
    guard let foregroundImageView = (foregroundVC as? Scaling)?.scalingImageView(transition: self) else { return }
    
    guard let backgroundUILabel = (backgroundVC as? Scaling)?.scalingUILabel(transition: self) else { return }
    guard let foregroundUILabel = (foregroundVC as? Scaling)?.scalingUILabel(transition: self) else { return }
    
    guard let backgroundContainer = (backgroundVC as? Scaling)?.scalingContainerView(transition: self) else { return }
    guard let foregroundContainer = (foregroundVC as? Scaling)?.scalingContainerView(transition: self) else { return }

    let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
    let uiLabelSnapshot =  UILabel(frame: backgroundUILabel.frame)
    let containerSnapshot = UIView(frame: backgroundContainer.frame)

    uiLabelSnapshot.text = backgroundUILabel.text
    uiLabelSnapshot.font = backgroundUILabel.font
    uiLabelSnapshot.textColor = backgroundUILabel.textColor
    
    imageViewSnapshot.contentMode = .scaleAspectFit
    imageViewSnapshot.layer.masksToBounds = true
    imageViewSnapshot.backgroundColor = .white
    
    containerSnapshot.backgroundColor = backgroundContainer.backgroundColor
    
    backgroundImageView.isHidden = true
    foregroundImageView.isHidden = true
    
    backgroundUILabel.isHidden = true
    foregroundUILabel.isHidden = true
    
    backgroundContainer.isHidden = true
    foregroundContainer.isHidden = true
    
    if navigationControllerOperation == .pop {
      containerSnapshot.shadowColor = .black
      containerSnapshot.shadowOpacity = 0.5
      containerSnapshot.shadowRadius = 10
      containerSnapshot.cornerRadius = 15
      
      imageViewSnapshot.cornerRadius = 115
    } else {
      uiLabelSnapshot.frame = foregroundUILabel.frame
      uiLabelSnapshot.numberOfLines = 0
      uiLabelSnapshot.sizeToFit()
    }
    
    let foregroundBGColor = foregroundVC.view.backgroundColor
    foregroundVC.view.backgroundColor = UIColor.clear
    containerView.backgroundColor = .white
    
    containerView.addSubview(backgroundVC.view)
    containerView.addSubview(foregroundVC.view)
    containerView.addSubview(containerSnapshot)
    containerView.addSubview(uiLabelSnapshot)
    containerView.addSubview(imageViewSnapshot)
    
    var transitionStateA = TransitionState.begin
    var transitionStateB = TransitionState.end
    
    if navigationControllerOperation == .pop {
      transitionStateA = .end
      transitionStateB = .begin
    }
    
    prepareViews(for: transitionStateA, containerView: containerView, backgroundVC: backgroundVC, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, backgroundUILabel: backgroundUILabel, foregroundUILabel: foregroundUILabel, snapshotImageView: imageViewSnapshot, snapshotUILabel: uiLabelSnapshot, backgroundContainer: backgroundContainer, foregroundContainer: foregroundContainer, snapshotContainer: containerSnapshot)
    
    foregroundVC.view.layoutIfNeeded()
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0, options: [], animations: {
      self.prepareViews(for: transitionStateB, containerView: containerView, backgroundVC: backgroundVC, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, backgroundUILabel: backgroundUILabel, foregroundUILabel: foregroundUILabel, snapshotImageView: imageViewSnapshot, snapshotUILabel: uiLabelSnapshot, backgroundContainer: backgroundContainer, foregroundContainer: foregroundContainer, snapshotContainer: containerSnapshot)
    }) { _ in
      backgroundVC.view.transform = .identity
      imageViewSnapshot.removeFromSuperview()
      uiLabelSnapshot.removeFromSuperview()
      containerSnapshot.removeFromSuperview()
      
      backgroundImageView.isHidden = false
      foregroundImageView.isHidden = false
      
      backgroundUILabel.isHidden = false
      foregroundUILabel.isHidden = false
      
      foregroundContainer.isHidden = false
      backgroundContainer.isHidden = false
      
      foregroundVC.view.backgroundColor = foregroundBGColor
      
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
  
  func prepareViews(for state:TransitionState, containerView: UIView, backgroundVC: UIViewController, backgroundImageView: UIImageView, foregroundImageView: UIImageView, backgroundUILabel: UIView, foregroundUILabel: UIView, snapshotImageView: UIImageView, snapshotUILabel: UIView, backgroundContainer: UIView, foregroundContainer: UIView, snapshotContainer: UIView){
    switch state {
    case .begin:
      backgroundVC.view.transform = .identity
      backgroundVC.view.alpha = 1
      
      snapshotImageView.frame = containerView.convert(backgroundImageView.frame, from: backgroundImageView.superview)
      snapshotUILabel.frame = containerView.convert(backgroundUILabel.frame, from: backgroundUILabel.superview)
      snapshotContainer.frame = containerView.convert(backgroundContainer.frame, from: backgroundContainer.superview)
    case .end:
      backgroundVC.view.alpha = 0
      snapshotImageView.frame = containerView.convert(foregroundImageView.frame, from: foregroundImageView.superview)
      snapshotUILabel.frame = containerView.convert(foregroundUILabel.frame, from: foregroundUILabel.superview)
      snapshotContainer.frame = containerView.convert(foregroundContainer.frame, from: foregroundContainer.superview)
    }
  }
}

extension ScaleTransitionDelegate: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if fromVC is Scaling && toVC is Scaling {
      self.navigationControllerOperation = operation
      return self
    } else {
      return nil
    }
  }
}

