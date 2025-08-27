


class PulseData {
    var t0: Float = 0
    var time: Array<Float> = [0]
    var initialized: Bool = false
    let reinitThreshold: Float = 5
    
    func append(t: Float) {
        if initialized {
            let dt = (t-t0)/1e9
            if dt > reinitThreshold {
                time = []
                t0 = 0
            } else {
                time.append(dt)
            }
        } else {
            initialized = true
        }
        t0 = t
    }
}
