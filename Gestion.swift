import Foundation

 

struct Etudiant {
    var id: Int
    var nom: String
    var prenom: String
    var notes: [String: Double]
    var paiements: [Transaction]
}

struct Transaction {
    var date: Date
    var montant: Double
    var description: String
}

 

 
 var etudiants: [Etudiant] = []
 var prochainID: Int = 1

// Montant total des frais scolaires
let montantTotalFrais: Double = 2000.0
 
 
func afficherSeparator() {
    print("\n" + String(repeating: "-", count: 40) + "\n")
}

// MARK: - Fonctions de Gestion des Etudiants

func ajouterEtudiant() {
    print("Entrez le nom de l'etudiant : ", terminator: "")
    let nom = readLine() ?? ""
    print("Entrez le prenom de l'etudiant : ", terminator: "")
    let prenom = readLine() ?? ""

    let matieres = ["Mathematiques", "Physique", "Chimie"]
    var notes: [String: Double] = [:]

    for matiere in matieres {
        while true {
            print("Entrez la note pour \(matiere) sur 100 : ", terminator: "")
            if let note = Double(readLine() ?? ""), note >= 0 && note <= 100 {
                notes[matiere] = note
                break
            } else {
                print("Note invalide. Veuillez entrer une note entre 0 et 100.")
            }
        }
    }

    let etudiant = Etudiant(id: prochainID, nom: nom, prenom: prenom, notes: notes, paiements: [])
    etudiants.append(etudiant)
    prochainID += 1
    print("Etudiant ajoute avec succes !")
    afficherSeparator()
}

func listerEtudiants() {
    if etudiants.isEmpty {
        print("Aucun étudiant enregistré.")
    } else {
        for etudiant in etudiants {
            print("ID: \(etudiant.id), Nom: \(etudiant.nom), Prénom: \(etudiant.prenom)")
            for (matiere, note) in etudiant.notes {
                print("  Matière: \(matiere), Note: \(note)")
            }
        }
    }
    afficherSeparator()
}

func calculerMoyenne() {
    print("Entrez l'ID de l'étudiant : ", terminator: "")
    let idStr = readLine() ?? ""

    if let id = Int(idStr), let etudiant = etudiants.first(where: { $0.id == id }) {
        let somme = etudiant.notes.values.reduce(0, +)
        let moyenne = somme / Double(etudiant.notes.count)
        print("La moyenne des notes de l'étudiant avec l'ID \(id) est \(moyenne)")
    } else {
        print("Étudiant non trouvé.")
    }
    afficherSeparator()
}

//   - Fonctions de Gestion de l'Économat

func ajouterPaiement() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    print("Entrez l'ID de l'étudiant : ", terminator: "")
    guard let idStr = readLine(), let id = Int(idStr),
          var etudiant = etudiants.first(where: { $0.id == id }) else {
        print("Étudiant non trouvé.")
        return
    }

    let paiementNumber = etudiant.paiements.count + 1
    var montantAttendu: Double = 0

    switch paiementNumber {
    case 1:
        montantAttendu = 500
    case 2:
        montantAttendu = 600
    case 3:
        montantAttendu = 900
    default:
        print("Tous les paiements ont déjà été effectués.")
        return
    }

    print("Entrez la date du paiement (format yyyy-MM-dd) : ", terminator: "")
    guard let dateStr = readLine(), let date = dateFormatter.date(from: dateStr) else {
        print("Date invalide.")
        return
    }

    print("Entrez le montant du paiement (ce paiement est le \(paiementNumber)ᵉ versement, exactement \(montantAttendu)) : ", terminator: "")
    guard let montantStr = readLine(), let montant = Double(montantStr), montant == montantAttendu else {
        print("Montant invalide. Le montant doit être exactement \(montantAttendu).")
        return
    }

    print("Entrez une description pour le paiement : ", terminator: "")
    let description = readLine() ?? ""

    let transaction = Transaction(date: date, montant: montant, description: description)
    etudiant.paiements.append(transaction)

    // Mise à jour de l'étudiant dans la liste globale
    if let index = etudiants.firstIndex(where: { $0.id == id }) {
        etudiants[index] = etudiant
    }

    print("Paiement ajouté avec succès !")
    afficherSeparator()
}

func listerPaiements() {
    print("Entrez l'ID de l'étudiant : ", terminator: "")
    guard let idStr = readLine(), let id = Int(idStr),
          let etudiant = etudiants.first(where: { $0.id == id }) else {
        print("Étudiant non trouvé.")
        return
    }

    if etudiant.paiements.isEmpty {
        print("Aucun paiement enregistré pour l'étudiant avec l'ID \(id).")
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        print("Liste des paiements pour l'étudiant avec l'ID \(id) :")
        for paiement in etudiant.paiements {
            let dateStr = dateFormatter.string(from: paiement.date)
            print("Date: \(dateStr), Montant: \(paiement.montant), Description: \(paiement.description)")
        }
    }
    afficherSeparator()
}

func calculerSolde() {
    print("Entrez l'ID de l'étudiant : ", terminator: "")
    guard let idStr = readLine(), let id = Int(idStr),
          let etudiant = etudiants.first(where: { $0.id == id }) else {
        print("Étudiant non trouvé.")
        return
    }

    let totalPaiements = etudiant.paiements.map { $0.montant }.reduce(0, +)
    let solde = montantTotalFrais - totalPaiements
    print("Le solde des frais scolaires pour l'étudiant avec l'ID \(id) est \(solde)")
    afficherSeparator()
}

// MARK: - Fonction d'Affichage du Menu

func afficherMenu() {
    print("""
    1. Gestion des étudiants
    2. Gestion de l'économat
    3. Quitter
    """)
}

func afficherMenuEtudiants() {
    while true {
        print("""
        1. Ajouter un étudiant
        2. Lister tous les étudiants
        3. Calculer la moyenne des notes par étudiant
        4. Retour
        """)
        print("")
         
          print("................................................")
        print("Choisissez une option : ", terminator: "")
       
        if let choix = readLine(), let option = Int(choix) {
            switch option {
            case 1:
                ajouterEtudiant()
            case 2:
                listerEtudiants()
            case 3:
                calculerMoyenne()
            case 4:
                return
            default:
                print("Option invalide, veuillez réessayer.")
            }
        } else {
            print("Entrée invalide, veuillez réessayer.")
        }
    }
}

func afficherMenuEconomat() {
    while true {
        print("""
        1. Ajouter un paiement de frais scolaires
        2. Lister les paiements de frais scolaires pour un étudiant
        3. Calculer le solde des frais scolaires pour un étudiant
        4. Retour
        """) 
           print("")
         
          print("................................................")
        print("Choisissez une option : ", terminator: "") 
        if let choix = readLine(), let option = Int(choix) {
            switch option {
            case 1:
                ajouterPaiement()
            case 2:
                listerPaiements()
            case 3:
                calculerSolde()
            case 4:
                return
            default:
                print("Option invalide, veuillez réessayer.")
            }
        } else {
            print("Entrée invalide, veuillez réessayer.")
        }
    }
}

//  - Fonction Principale

func main() {
    while true {
        afficherMenu()
           print("")
         
          print("................................................")
        print("Choisissez une option : ", terminator: "") 
        if let choix = readLine(), let option = Int(choix) {
            switch option {
            case 1:
                afficherMenuEtudiants()
            case 2:
                afficherMenuEconomat()
            case 3:
                print("Au revoir!")
                return
            default:
                print("Option invalide, veuillez réessayer.")
            }
        } else {
            print("Entrée invalide, veuillez réessayer.")
        }
    }
}

// Lancement du programme
main()
