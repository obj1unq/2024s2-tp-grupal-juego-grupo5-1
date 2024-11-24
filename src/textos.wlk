import turno.*
import wollok.game.*
import map.*
import characters.*
import cabezal.*
import direcciones.*
import edificios.*
import objetos.*
import colores.*

object cantidadTurnos {
  
    method position() {
        return game.at(18, 11)
    }

    method text() {
        return "       Turnos restantes: " + mapa.nivelActual().turnosDelNivel()
    }

    method textColor() {
      return paleta.blanco()
    }

}

object textoReservas {

    method position() {
        return game.at(18, 10)
    }

    method text() {
        return "     Oro: "  + castillo.oroEnReserva() + "      Piedra: " + castillo.piedrasEnReserva() + "      Huevos: " + castillo.huevosEnReserva()
    }

    method textColor() {
      return paleta.blanco()
    }
}

object pjActual {
    var property image = null

    method position() {
        return game.at(18, 7)
    }
}

object statsPjActual {

    method position() {
        return game.at(17, 8)
    }

    method text() {
        return "Ataque: " + cabezal.seleccionActualAliada().ataqueBase().toString() + "    Defensa: " + cabezal.seleccionActualAliada().defensaBase().toString()
    }

    method textColor() {
      return paleta.blanco()
    }
}



