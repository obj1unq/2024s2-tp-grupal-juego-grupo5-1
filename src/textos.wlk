import wollok.game.*
import map.*
import characters.*
import cabezal.*
import edificios.*
import colores.*


class TextoHUD {

    method position()

    method text()

    method textColor()
}

object cantidadTurnos inherits TextoHUD {
  
    override method position() {
        return game.at(18, 11)
    }

    override method text() {
        return "       Turnos restantes: " + mapa.nivelActual().turnosDelNivel()
    }

    override method textColor() {
      return paleta.blanco()
    }

}

object textoReservas inherits TextoHUD {

    override method position() {
        return game.at(18, 10)
    }

    override method text() {
        return "     Oro: "  + castillo.oroEnReserva() + "      Piedra: " + castillo.piedrasEnReserva() + "      Huevos: " + castillo.huevosEnReserva()
    }

    override method textColor() {
      return paleta.blanco()
    }
}

object pjActual {
    var property image = null

    method position() {
        return game.at(18, 7)
    }

    method actualizarImage(imagen) {
        image = imagen
    }

    method removerPjActual() {
        game.removeVisual(self)
    }
}

object statsPjActual inherits TextoHUD {

    override method position() {
        return game.at(18, 8)
    }

    override method text() {
        return if (cabezal.hayAliadoSeleccionado()) {
            "          Ataque: " + cabezal.seleccionActualAliada().ataqueBase().toString() + 
            "    Defensa: " + cabezal.seleccionActualAliada().defensaBase().toString()
        } else {
            null
        }
    }

    override method textColor() {
      return paleta.blanco()
    }
}


object probabilidades inherits TextoHUD {

    override method position() {
        return game.at(18, 4)
    }

    override method text() {
        return "                Probabilidad de victoria VS:"
    }

    override method textColor() {
      return paleta.blanco()
    }
}
object probabilidadesDragonGolem inherits TextoHUD {

    override method position() {
        return game.at(18, 3)
    }

    override method text() {
        return if (cabezal.hayAliadoSeleccionado()) {
            "              Dragon: " + (cabezal.seleccionActualAliada().ataqueBase() / (cabezal.seleccionActualAliada().ataqueBase() + 4 )).truncate(2) +
                    "               Golem: "  + (cabezal.seleccionActualAliada().ataqueBase() / (cabezal.seleccionActualAliada().ataqueBase() + 10 )).truncate(2)
        } else {
            null
        }
    }

    override method textColor() {
      return paleta.blanco()
    }
}

object probabilidadesComandSol inherits TextoHUD{

    override method position() {
        return game.at(18, 2)
    }

    override method text() {
        return if (cabezal.hayAliadoSeleccionado()) {
            "                  Comandante: " + (cabezal.seleccionActualAliada().ataqueBase() / (cabezal.seleccionActualAliada().ataqueBase() + 5 )).truncate(2) +
                    "        Soldado: "  + (cabezal.seleccionActualAliada().ataqueBase() / (cabezal.seleccionActualAliada().ataqueBase() + 4 )).truncate(2)
        } else {
            null
        }
    }

    override method textColor() {
      return paleta.blanco()
    }
}

object probabilidadesArqMag inherits TextoHUD {

    override method position() {
        return game.at(18, 1)
    }

    override method text() {
        return if (cabezal.hayAliadoSeleccionado()) {
            "              Mago: " + (cabezal.seleccionActualAliada().ataqueBase() / (cabezal.seleccionActualAliada().ataqueBase() + 2 )).truncate(2) +
                    "               Arquero: "  + (cabezal.seleccionActualAliada().ataqueBase() / (cabezal.seleccionActualAliada().ataqueBase() + 2 )).truncate(2)
        } else {
            null
        }
    }

    override method textColor() {
      return paleta.blanco()
    }
}