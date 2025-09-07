import Accelerate

class PulseData {
    var t0: Double = 0
    var time: Array<Double> = [0]
    var initialized: Bool = false
    let reinitThreshold: Double = 5
    
    var rates: Array<Double> = []
    
    func append(t: Double) {
        if initialized {
            let dt = (t-t0)/1e9
            if dt > reinitThreshold {
                time = []
                rates = []
                t0 = 0
            } else {
                time.append(dt)
            }
        } else {
            initialized = true
        }
        t0 = t
    }
    
    func average(v: Array<Double>) -> Double {
        var res: Double = 0
        for value in v {
            res += value
        }
        return res / Double(v.count)
    }
    
    func compute_rate() {
        let window_size = min(time.count/2, 5)
        if window_size == 0 {
            return
        }

        var _rates: Array<Double> = []
        for i in (window_size/2)...(time.count-window_size/2-1) {
            let v: Array<Double> = Array(time[(i-window_size/2)...(i+window_size/2)])
            let mu: Double = average(v: v)
            _rates.append(60 / mu)
        }
        rates = _rates
    }
}
