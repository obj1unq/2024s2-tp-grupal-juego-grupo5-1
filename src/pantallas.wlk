import wollok.game.*
import map.*

class Pantalla {

    var property position = game.at(0,0)

}


object inicio inherits Pantalla {

    method image() {
        return "pantallaInicioNew.png"
    }
}

object finVictoria inherits Pantalla {

    method image() {
        return "pantallaVictoria2.jpg"
    }
}

object finDerrotaTurnos inherits Pantalla {

    method image() {
        return "pantallaDerrotaTurnos.png"
    }
}

object finDerrotaTropas inherits Pantalla {

    method image() {
        return "pantallaDerrotaTropas.png"
    }
}