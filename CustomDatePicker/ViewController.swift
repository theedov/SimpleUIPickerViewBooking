//
//  ViewController.swift
//  CustomDatePicker
//
//  Created by Bogdan on 14/7/20.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var selectedDateTxt: UILabel!
    
    //MARK: Variables
    private var appointmentDays = [AppointmentDay]()
    private var appointmentTimes = [AppointmentTime]()
    private var selectedDate: AppointmentDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAvailableDates()
        createApointmentDatePicker()
    }
    
    func createApointmentDatePicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func getAvailableDates() {
        activityIndicator.startAnimating()
        RESTful.request(path: "https://dovgopol.dev/api/testApi", method: "GET", parameters: nil, headers: nil) { [weak self] result in
            
            guard let self = self else {return}
            
            switch result {
            
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    self.appointmentDays = try decoder.decode([AppointmentDay].self, from: data)
                    
                    self.selectedDate = AppointmentDate(day: self.appointmentDays[0].day, time: self.appointmentDays[0].times[0].time)
                    DispatchQueue.main.async {
                        self.pickerView.reloadAllComponents()
                        self.selectedDateTxt.text = "\(self.selectedDate.day) \(self.selectedDate.time)"
                    }
                } catch(let error) {
                    debugPrint(error)
                }
            case .failure(let error):
                debugPrint(error)
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

//MARK: Custom UIPickerView
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return appointmentDays.count
        case 1:
            return appointmentTimes.count
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            appointmentTimes = appointmentDays[row].times
            pickerView.reloadComponent(1)
            return appointmentDays[row].day
        case 1:
            return appointmentTimes[row].time
        default:
            return nil
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedDay = 0
        switch component {
        case 0:
            selectedDay = row
            selectedDate.day = appointmentDays[selectedDay].day
            selectedDate.time = appointmentDays[selectedDay].times.first?.time ?? "--"
        case 1:
            selectedDate.time = appointmentDays[selectedDay].times[row].time
        default: break
        }
        
        selectedDateTxt.text = "\(selectedDate.day) \(selectedDate.time)"
    }
}
