import Foundation

struct VendingMachineProduct {
    var name: String
    var code: Int
    var amount: Int
    var price: Double

    init(name: String, amount: Int, price: Double, code: Int) {
        self.name = name
        self.amount = amount
        self.price = price
        self.code = code
    }
}

//TODO: Definir os erros
enum VendingMachineError: Error {
    case productNotFound
    case productUnavaliable
    case insufficientFunds
    case productStuck
}

class VendingMachine {

    private var estoque: [VendingMachineProduct]
    private var money: Double
    public var avaliableProducts: [String] = []
    
    init(estoque: [VendingMachineProduct]) {
        self.estoque = estoque
        self.money = 0
    }

    func getProducts(with codes: [Int], with money: Double) throws {

        self.money = money

        for i in 0..<codes.count {
            let optionalCode = estoque.first { (product) -> Bool in
                return product.code == codes[i]
            }

            guard let selectedProduct = optionalCode else { throw VendingMachineError.productNotFound}
            getAvaliableProducts(product: selectedProduct)

            guard selectedProduct.amount > 0 else { throw  VendingMachineError.productUnavaliable }

            guard selectedProduct.price <= self.money else { throw  VendingMachineError.insufficientFunds }

            self.money -= selectedProduct.price
            if Int.random(in: 0...100) < 10 {
                throw VendingMachineError.productStuck
            }
        }
    }

    func getAvaliableProducts(product: VendingMachineProduct) {
        avaliableProducts.append(product.name)
    }
    
    func getTroco() -> Double {
        let money = self.money
        self.money = 0.0
        return money
    }
}

let chocolateBar = VendingMachineProduct(name: "Barra de chocolate", amount: 20, price: 5.0, code: 001)
let cebolitos = VendingMachineProduct(name: "cebolitos", amount: 5, price: 2.5, code: 002)

let products = [chocolateBar, cebolitos]
let vendingMachine = VendingMachine(estoque: products)

do {
    try vendingMachine.getProducts(with: [002, 001, 003], with: 20.0)
    let troco = vendingMachine.getTroco()
    let products = vendingMachine.avaliableProducts
    print("Compra realizada com sucesso, você adquiriu \(products) seu troco é \(troco)")

} catch let err as VendingMachineError {
    switch err {
    case .productStuck:
        print("O produto prendeu na máquina")
    case .insufficientFunds :
        print("Falta dinheiro")
    case .productNotFound:
        print("Não foram encontrados todos os códigos")
    case .productUnavaliable:
       print("O produto está indisponível")
    }
}


