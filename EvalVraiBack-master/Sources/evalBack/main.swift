import Kitura
import HeliumLogger
import KituraStencil
import Foundation

HeliumLogger.use()

struct HelloResponse : Codable {
    let result : String // contient "Hello + prenom + nom"
    // var recursion : HelloResponse?
}

let router = Router()

router.all(middleware: [BodyParser(), StaticFileServer(path: "./Public")])
router.add(templateEngine: StencilTemplateEngine())

var jsonPizzas = [
                    ["nom":"4 Saisons", "id": 1],
                    ["nom":"Regina", "id": 2]
                ]
var jsonCommandes = [
                        ["number":"1", "delivred": false, "pizza": 1],
                        ["number":"2", "delivred": false, "pizza": 2]
                    ]
let jsonIngredients = [
                        ["nom":"Tomate", "id": 1],
                        ["nom":"Oignon", "id": 2],
                        ["nom":"Poivron", "id": 3],
                        ["nom":"Lardon", "id": 4],
                        ["nom":"Oeuf", "id": 5],
                        ["nom":"Mergez", "id": 6],
                        ["nom":"Chorizo", "id": 7],
                        ["nom":"Boeuf Hache", "id": 8],
                        ["nom":"Becon", "id": 9],
                        ["nom":"Saumon", "id": 10],
                        ["nom":"Chedar", "id": 11],
                        ["nom":"Chevre", "id": 12],
                        ["nom":"Emental", "id": 13],
                        ["nom":"Olive", "id": 14],
                        ["nom":"Champignon", "id": 15],
                        ["nom":"Pomme de terre", "id": 16],
                        ["nom":"Creme fraiche", "id": 17]
                    ]
var jsonRecette = [
                    ["idPizza": 1, "idIngredient": 1],
                    ["idPizza": 1, "idIngredient": 2],
                    ["idPizza": 1, "idIngredient": 9],
                    ["idPizza": 1, "idIngredient": 11],
                    ["idPizza": 2, "idIngredient": 6],
                    ["idPizza": 2, "idIngredient": 14],
                    ["idPizza": 2, "idIngredient": 16],
                    ["idPizza": 2, "idIngredient": 9]
                ]
var itemsPosted = ["pizzas": jsonPizzas,"commandes": jsonCommandes,"ingredients": jsonIngredients,"recette": jsonRecette]

router.get("/") { request, response, next in
    var jsonToReturn = [[String: Any]]()
    for i in jsonCommandes{
        for j in jsonPizzas{
            if i["pizza"] as! Int == j["id"] as! Int{
                jsonToReturn.append(["number":i["number"] as Any, "delivred": i["delivred"] as Any, "pizza": j["nom"] as Any])
            }
        }
    }
    try response.render("Home.stencil", context: ["commandes": jsonToReturn])
    
    next()
}

router.get("/get_pizzas") { request, response, next in
    response.send(json: jsonPizzas)
    next()
}

router.post("/get_ingredient") { request, response, next in
    if let body = request.body?.asJSON {
        var ingredientsTosend = [String]()
        if body["pizzaId"] != nil, let p = body["pizzaId"] {
            for i in jsonRecette{
                if (i["idPizza"] == (p as! Int)) {
                    ingredientsTosend.append(jsonIngredients[i["idIngredient"]! - 1]["nom"] as! String)
                }
                
            }
            
        }
        response.send(json: ingredientsTosend)
    } else {
        print("p")
        response.status(.notFound)
    }
    
    next()
}

router.post("/get_ingredient_by_name") { request, response, next in
    if let body = request.body?.asJSON {
        var recetteToSend = [String]()
        if body["ingredientName"] != nil, let p = body["ingredientName"] {
            var ingredientId = 0
            for j in jsonIngredients {
                if j["nom"] as! String == p as! String  {
                    ingredientId = j["id"] as! Int
                }
            }
            for i in jsonRecette{
                if (i["idIngredient"] == ingredientId) {
                    recetteToSend.append(jsonPizzas[i["idPizza"]! - 1]["nom"] as! String)
                }
                
            }
            
        }
        response.send(json: recetteToSend)
    } else {
        print("p")
        response.status(.notFound)
    }
    
    next()
}

router.get("/create_recette") { request, response, next in
    
    try response.render("NewRecette.stencil", context: ["ingredients": jsonIngredients])
    
    next()
}

router.post("/add_recette") { request, response, next in
    if let body = request.body?.asURLEncoded {
        if body["pizzaName"] != nil, let p = body["pizzaName"] {
            let idPizza = jsonPizzas.count + 1
            for i in jsonIngredients{
                let iId = String(i["id"]! as! Int)
                if (body[iId] != nil) {
                    jsonPizzas.append(["nom" : p, "id" : idPizza])
                    jsonRecette.append(["idIngredient" : Int(iId)!, "idPizza" : idPizza])
                    print(idPizza)
                }
                
            }
        }
        try response.render("NewRecette.stencil", context: ["ingredients": jsonIngredients])
    } else {
        response.status(.notFound)
    }
    
    next()
}

router.post("/modify_commande_status") { request, response, next in
    if let body = request.body?.asURLEncoded {
            var jsonToReturn = [[String: Any]]()
            var cpt = 0
            for i in jsonCommandes{
                let iId = i["number"] as! String
                if (body[iId] != nil) {
                    jsonCommandes[cpt]["delivred"] = true
                    print(jsonCommandes)
                } else {
                    jsonCommandes[cpt]["delivred"] = false
                }
                for j in jsonPizzas{
                    if i["pizza"] as! Int == j["id"] as! Int{
                        jsonToReturn.append(["number":i["number"] as Any, "delivred": jsonCommandes[cpt]["delivred"] as Any, "pizza": j["nom"] as Any])
                    }
                }
                cpt += 1
            }
            try response.render("Home.stencil", context: ["commandes": jsonToReturn])
    } else {
        response.status(.notFound)
    }
    
    next()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
