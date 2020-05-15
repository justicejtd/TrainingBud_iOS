class Instrument {
    
    let brand: String
    
    init(brand: String) {
        self.brand = brand
        self.test()
    }
    
    private func test(){
        print("Testing method test")
    }
}
var instrument: Instrument = Instrument(brand: "test")

