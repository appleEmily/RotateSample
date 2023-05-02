//
//  ViewController.swift
//  RotateSample
//
//  Created by Emily Nozaki on 2023/05/03.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var compassImageView: UIImageView!
    
    var lastRotation: CGFloat = 0
    //スムーズに動かすために用意しているよ。CADisplayLinkはアニメーションや画面の更新処理をスムーズにさせたい時に使うよん。
    var displayLink: CADisplayLink?
    var targetRotation: CGFloat = 0
    var currentRotation: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIPanGestureRecognizerを作成して、ビューに追加する
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(rotateCompass(_:)))
        compassImageView.addGestureRecognizer(panGesture)
        
        //CADisplayLinkのインスタンスを作成！updateRotationメソッドを呼び出すように設定
        //インスタンスって何？については、別で送ったのを見てねー。
        displayLink = CADisplayLink(target: self, selector: #selector(updateRotation))
        // displayLinkをメインスレッドのRunLoopに追加し、デフォルトモードで動作させる
        displayLink?.add(to: .main, forMode: .default)
    }
    
    deinit {
        displayLink?.invalidate()
    }
    
    @objc func rotateCompass(_ sender: UIPanGestureRecognizer) {
        
        let compassCenter = CGPoint(x: compassImageView.bounds.size.width / 2.0, y: compassImageView.bounds.size.height / 2.0)
        
        switch sender.state {
            //回し始め
        case .began:
            //前回の回転を保持するために、現在の回転角度をlastRotationに入れておく。
            lastRotation = atan2(sender.location(in: compassImageView).y - compassCenter.y, sender.location(in: compassImageView).x - compassCenter.x)
            print(lastRotation)
            //実際に動いた分動かす。
        case .changed:
            //指が移動した後の角度を求める。
            let newRotation = atan2(sender.location(in: compassImageView).y - compassCenter.y, sender.location(in: compassImageView).x - compassCenter.x)
            //今の角度-前回いた位置の角度で変化量を出す。
            let angleDifference = newRotation - lastRotation
            //targetRotation(すなわち、目的のいきたい角度)を求める。
            targetRotation = currentRotation + angleDifference
        default:
            break
        }
    }
    
    //スムーズに動かすためのメソッド
    @objc func updateRotation() {
        //回転のスピードを決める。大きくすると早く、小さくするとゆっくりになるよ。
        let rotationSpeed: CGFloat = 0.2
        //1回の動きの後にくる角度はここで求めているよ。
        currentRotation = currentRotation + (targetRotation - currentRotation) * rotationSpeed
        compassImageView.transform = CGAffineTransform(rotationAngle: currentRotation)
    }


}

