//
//  Product.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/25/21.
//

import Foundation
import UIKit

class Product: ObservableObject, Identifiable {
    var id: Int { data.id }
    var data: ProductData
    @Published var defaultImage: UIImage?
    @Published var galleryImages: [UIImage?] = []
    
    init(data: ProductData) {
        self.data = data
        fetchDefaultImage()
        fetchGalleryImages()
    }
     
    func fetchImageFromURL(_ url: URL?, completion: @escaping (UIImage?) -> ()) {
        if let url = url {
            
            if let cachedImage = ImageCache().get(forKey: url.absoluteString) {
                completion(cachedImage)
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, resp, err in
                if let err = err {
                    print("Could not fetch image for url: \(url.absoluteString), error: \(err)")
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    ImageCache().set(forKey: url.absoluteString, image: image)
                    completion(image)
                }
            }.resume()
        }
    }
    
    func fetchDefaultImage() {
        fetchImageFromURL(data.defaultImageURL) { [weak self] image in
            if image != nil {
                DispatchQueue.main.async {
                    self?.defaultImage = image
                }
            }
        }
    }
    
    func fetchGalleryImages() {
        data.galleryImageURLs?.forEach { fetchImageFromURL($0) { image in
            if image != nil {
                DispatchQueue.main.async {
                    self.galleryImages.append(image)
                }
            }
        }}
    }
    
    static var sampleProduct: Product {
        let productData = ProductData()
        productData.title = "Privat Kaffee Latin Grande - 500 g Gemahlen"
        productData.product_id = 2000007956
        productData.tcm_article_number = 600
        productData.type = "coffee"
        productData.description = ["structured" : "Privat Kaffee Latin Grande Willkommen in einer der vielfältigsten Kaffeeregionen der Welt –¡Bienvenidos América Latina! Auf bis zu 1.500 Meter gedeihen hier unsere sonnenverwöhnten Arabica-Bohnen. Zum Beispiel an den zerklüfteten Steilhängen Guatemalas, im grünen Hochland Brasiliens oder in den bergigen Anbaugebieten Honduras’. Nur die besten Bohnen Lateinamerikas schaffen es in unseren Privat Kaffee Latin Grande.\n\n\n\nDas Ergebnis ist ein vollendeter Kaffee: ausgewogen im Geschmack, mit einer zarten Schokoladennote. Frisch geerntet und liebevoll von unseren Röstmeistern veredelt. Ein exklusiver Genuss, Rainforest Alliance zertifiziert und mit Ursprungsgarantie. Produktdetails:\n Inhalt: 500 g\n\nIntensität: 3 von 6 Bohnen\n\nRöstkaffee, gemahlen\n\n\n\nUnter Schutzatmosphäre verpackt.\n\nKühl, trocken und dunkel lagern.\n\n Tchibo GmbH\n Überseering 18,\n\nD–22297 Hamburg\n\n Hinweis:\n Die ausgelobten Preise beziehen sich ausschließlich auf Bestellungen im Internet. Der von uns gelieferte Kaffee darf gewerbsmäßig nur zubereitet weiter vertrieben werden.\n\nAufbewahrung und Zubereitung Damit das feine Aroma unserer Kaffees vor Sauerstoff, Feuchtigkeit und Licht geschützt wird, verpacken wir gemahlene Kaffees ausschließlich im Aromapack. Während Sie die eine Hälfte genießen, bleibt die andere aromafrisch geschützt. \n\n\n\n Aufbewahrungshinweis\n Kühl und trocken lagern.\n\nAm Besten bewahren Sie die angebrochene Packung luftdicht z.B. in einer Aromadose auf.\n\n\n\n Zubereitung\n Die optimale Menge Kaffee pro Tasse ist 7 - 9g (= ein gestrichenes Kaffeelot).\n\nQualität und Verantwortung 100 % Tchibo Arabica aus nachhaltigem Anbau\n\nBeste Arabica-Qualität entsteht nur unter optimalen Bedingungen.\n\n\n\nUm Ihnen auch in Zukunft diese herausragende Qualität bieten zu können, setzen wir für unseren Privat Kaffees von Rainforest-Alliance-zertifizierten Farmen ein. \n\n\n\nIn Kooperation mit der unabhängigen Umweltschutzorganisation Rainforest Alliance unterstützen wir die nachhaltige Verbesserung der Lebensbedingungen für Mensch und den Erhalt der Natur in den Ursprungsländern unserer Kaffees.\n\nwww.rainforest-alliance.org/de\n\n\n\nMount Kenya Project\n\nAußerdem unterstützen wir in eigenen Projekten Kaffeefarmer und ihre Familien in den Anbaugebieten wie z.B. Kenia, Guatemala und Kolumbien. So unterstützen wir u.a. Farmerfrauen am Mount Kenya Zugang zu Trinkwasser zu erhalten. Mehr zu dem Projekt erfahren Sie unter: www.tchibo.de/mount-kenya\n\n\n\nRöstung\n\nJede der für Privat Kaffee ausgewählten Ernten wird von uns aromaveredelnd einzeln geröstet. \n\n\n\nNur so kann sich der unverwechselbare Charakter ihrer Herkunft, der jedem Privat Kaffee seinen besonderen Geschmack verleiht, zur höchsten Vollendung entfalten.\n\nRainforest Alliance Certified™ Bestimmt ist Ihnen beim Einkauf schon einmal der grüne Frosch der Rainforest Alliance aufgefallen, doch wofür steht er eigentlich?\n\n\n\nRainforest Alliance setzt sich für den Schutz sensibler Ökosysteme, wie der Tier- und Pflanzenwelt, ein und fördert die nachhaltige Bewirtschaftung von Landflächen. Dazu gehören auch angemessene Lebens- und Arbeitsbedingungen für die Kaffeefarmer und ihre Familien. \n\n\n\nUnsere Kaffeeprodukte mit dem grünen Frosch wurden auf ökologisch und sozial verträgliche Weise erzeugt.\n\n\n\nMit den nachhaltigen Produkten wie diesem 100% zertifizierten Kaffee bringen Sie etwas Gutes ins Rollen. Für andere, die Umwelt, aber auch für sich selbst. Machen Sie mit und werden Sie Teil einer verantwortungsvolleren Welt! Mehr Infos unter: tchibo.de/nachhaltigkeit\n\nTchibo Community Produkttest 50 Mitglieder der Tchibo Community haben den Latin Grande getestet. Hier lesen Sie das Testurteil:\n\n\n\n Ansprechendes Design, sehr guter Geschmack\n „Bereits beim Öffnen des Latin Grande duftete der Kaffee sehr lecker und ich konnte es kaum erwarten, ihn mit meinem Vollautomaten zuzubereiten. Sowohl Schwarz als auch als Latte Macchiato fand ich ihn geschmacklich sehr gut. Besonders die schokoladige Note entsprach genau meinem Geschmack. Auch die Verpackung fand ich sehr gelungen und ansprechend. Ich werde den Latin Grande auf jeden Fall weiterempfehlen.“ – Denise S.\n\n\n\nWeitere Bewertungen des Latin Grande finden Sie in der Tchibo Community unter: community.tchibo.de/de-de/produkttests",
                                   "default" : "Ausgewogen im Geschmack mit zarter Schokoladennote",
                                   "long" : "Privat Kaffee Latin Grande Willkommen in einer der vielfältigsten Kaffeeregionen der Welt –¡Bienvenidos América Latina! Auf bis zu 1.500 Meter gedeihen hier unsere sonnenverwöhnten Arabica-Bohnen. Zum Beispiel an den zerklüfteten Steilhängen Guatemalas, im grünen Hochland Brasiliens oder in den bergigen Anbaugebieten Honduras’. Nur die besten Bohnen Lateinamerikas schaffen es in unseren Privat Kaffee Latin Grande.    Das Ergebnis ist ein vollendeter Kaffee: ausgewogen im Geschmack, mit einer zarten Schokoladennote. Frisch geerntet und liebevoll von unseren Röstmeistern veredelt. Ein exklusiver Genuss, Rainforest Alliance zertifiziert und mit Ursprungsgarantie. Produktdetails:  Inhalt: 500 g  Intensität: 3 von 6 Bohnen  Röstkaffee, gemahlen    Unter Schutzatmosphäre verpackt.  Kühl, trocken und dunkel lagern.   Tchibo GmbH  Überseering 18,  D–22297 Hamburg   Hinweis:  Die ausgelobten Preise beziehen sich ausschließlich auf Bestellungen im Internet. Der von uns gelieferte Kaffee darf gewerbsmäßig nur zubereitet weiter vertrieben werden. Ausgewogen im Geschmack mit zarter Schokoladennote Neuer Name, neue Verpackung, gleiche Qualität 100% Arabica-Kaffeebohnen Rainforest Alliance zertifiziert 2 x 250 g Aromapackung"]
        productData.defaultImageURL = URL(string: "https://www.tchibo.de/newmedia/art_img/MAIN_HD-IMPORTED/9d990672f1ea9e5/privat-kaffee-latin-grande-9-x-500-g-gemahlen.jpg")
        productData.galleryImageURLs = [URL(string: "https://www.tchibo.de/newmedia/art_img/MAIN_HD-IMPORTED/29f50672f1ea9e5/privat-kaffee-african-blue-9-x-500-g-gemahlen.jpg")]
        let product = Product(data: productData)
        product.defaultImage = UIImage(named: "Coffee")
        product.galleryImages = [UIImage(named: "Coffee"), UIImage(named: "Coffee"), UIImage(named: "Coffee")]
        
        return product
    }
}

class ProductData: Decodable, Identifiable {
    var id: Int { product_id! }
    var tcm_article_number: Int?
    var product_id: Int?
    var type: String?
    var title: String?
//    var size: String?
//    var color: String?
//    var material: String?
//    var pattern: String?
    var price: [String: String] = [:]
    var price_amount: Float? { Float( price["amount"] ?? "5.99" ) }
    var description: [String:String] = [:]
    var defaultDescription: String? { description["default"] }
    var longDescription: String? { description["long"] }
    var structuredDescription: String? { description["structured"] }
    var defaultImageURL: URL?
    var galleryImageURLs: [URL?]? = []
   
    
   
    
//    enum CodingKeys: String, CodingKey {
//        case product_id, type, title, size, color, material, pattern, description, defaultImage
//        case article_number = "tcm_article_number"
//
//    }
}
