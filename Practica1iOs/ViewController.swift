//
//  ViewController.swift
//  Practica1iOs
//
//  Created by Alex on 10/6/18.
//  Copyright © 2018 Alex Cuevas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet var btns: [UIButton]!
    @IBOutlet weak var lbTimer: UILabel!
    @IBOutlet weak var lbPunts: UILabel!
    @IBOutlet weak var lbFinal: UILabel!
    @IBOutlet weak var lbRecord: UILabel!
    @IBOutlet weak var btnVolver: UIButton!
    
    var timer = Timer()
    var arrayRandoms: [Int] = []
    var punts: Int = 0
    var temps: Int = 30
    let ratioInterval : Double = 150
    var puntsMax : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        iniciarJuego()
        timerStart()
    }
        
    
    func iniciarJuego(){
        temps = 30
        lbTimer.text = String(temps)
        lbRecord.text = String(puntsMax)
        btnVolver.isEnabled = false
        btnVolver.isHidden = true
        arrayRandoms.removeAll()
        progressBar.progress = 1
        for _ in 1...6{
            arrayRandoms.append(Int.random(in: -100...100))
        }
        var i = 0
        for btn in btns{
            btn.setTitle(String(arrayRandoms[i]), for: UIControl.State.normal)
            btn.isHidden = false
            btn.isEnabled = true
            i += 1
        }
        arrayRandoms.sort()
    }
    
    func timerStart(){
        var interval : Double = (ratioInterval/Double(punts))
        if(punts == 0 || interval > 1){
            interval = 1
        }
        //a mayor puntuacion mas rapido va pero si los puntos son 0 lo igualo
        // constante/0 = infinito
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self,   selector: (#selector(ViewController.actualizaLbTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func actualizaLbTimer(){
        var progress : Float
        temps -= 1
        lbTimer.text = String(temps)
        if temps <= 0{
            hasPerdido()
            progress = 0
        }else{
            progress = (Float(temps) / Float(30))
        }
        progressBar.setProgress((progress), animated: true);
    }
    
    func hasPerdido(){
        timer.invalidate()
        for btn in btns{
            btn.isEnabled = false
            btn.isHidden = true
        }
        btnVolver.isEnabled = true
        btnVolver.isHidden = false
        lbFinal.text = "has perdido"
        lbFinal.isHidden = false
        if(punts>puntsMax){
            puntsMax = punts
        }
    }
    
    
    @IBAction func btnPulsado(_ sender: AnyObject) {
        let button = sender as! UIButton
        if Int((button.titleLabel?.text)!) == arrayRandoms[0]{
            button.isEnabled = false
            button.isHidden = true
            arrayRandoms.remove(at: 0)
            punts += 10
            lbPunts.text = String(punts)
        }else{
            temps -= 10;
            lbTimer.text = String(temps)
        }
        if (arrayRandoms.count == 0){
            timer.invalidate()
            timerStart()
            iniciarJuego()
        }
    }

    @IBAction func volverAEmpezarPulsado(_ sender: Any) {
        punts = 0
        timerStart()
        iniciarJuego()
        lbFinal.isHidden = true
        lbPunts.text = String(punts)
    }
}

