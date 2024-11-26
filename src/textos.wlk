import wollok.game.*
import map.*
import characters.*
import cabezal.*
import edificios.*
import colores.*


class TextoHUD {

    method position()

    method text() {
        return if (cabezal.hayAliadoSeleccionado()) {
            self.primerTexto() + self.segundoTexto()
        } else {
            null
        }
    }

    method primerTexto() 

    method segundoTexto()

    method textColor() {
        return paleta.blanco()
    }
}

class ProbabilidadesBatallas inherits TextoHUD {

    override method primerTexto() {
        return self.primerEnemigoAEvaluar() + self.probabilidad(self.defensaPrimerEnemigo()) + "%"
    }

    override method segundoTexto() {
        return self.segundoEnemigoAEvaluar() + self.probabilidad(self.defensaSegundoEnemigo()) + "%"
    }

    method primerEnemigoAEvaluar()

    method segundoEnemigoAEvaluar()
    
    method probabilidad(defensa) {
        return ((cabezal.seleccionActualAliada().ataqueBase() / (cabezal.seleccionActualAliada().ataqueBase() + defensa)).truncate(2)) * 100
    }
    
    method defensaPrimerEnemigo() 

    
    method defensaSegundoEnemigo() 
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

object cantidadTurnos inherits TextoHUD {
  
    override method position() {
        return game.at(18, 11)
    }

    override method text() {
        return self.primerTexto()
    }

    override method primerTexto() {
        return "       Turnos restantes: " + mapa.nivelActual().turnosDelNivel()
    }

    override method segundoTexto() {} // No hace nada ya que no lo necesito en este caso.


}

object textoReservas inherits TextoHUD {

    override method position() {
        return game.at(18, 10)
    }

    override method text() {
        return self.primerTexto()
    }

    override method primerTexto() {
        return "     Oro: "  + castillo.oroEnReserva() + "      Piedra: " + castillo.piedrasEnReserva() + "      Huevos: " + castillo.huevosEnReserva()

    }

    override method segundoTexto() {} // No hace nada ya que no lo necesito en este caso.

}


object statsPjActual inherits TextoHUD {

    override method position() {
        return game.at(18, 8)
    }

    override method primerTexto() {
        return "          Ataque: " + cabezal.seleccionActualAliada().ataqueBase().toString()
    }

    override method segundoTexto() {
        return "    Defensa: " + cabezal.seleccionActualAliada().defensaBase().toString()
    }

}


object probabilidades inherits TextoHUD {

    override method position() {
        return game.at(18, 4)
    }

    override method text() {
        return self.primerTexto()
    }

    override method primerTexto() {
        return "                Probabilidad de victoria VS:"
    }

    override method segundoTexto() {} // No hace nada ya que no lo necesito en este caso.
}



object probabilidadesDragonGolem inherits ProbabilidadesBatallas {

    override method position() {
        return game.at(18, 3)
    }

    override method primerEnemigoAEvaluar() {
        return "              Dragon: "
    }

    override method defensaPrimerEnemigo() {
        return 4
    }

    override method segundoEnemigoAEvaluar() {
        return "               Golem: "
    }

    override method defensaSegundoEnemigo() {
        return 10
    }
}

object probabilidadesComandSol inherits ProbabilidadesBatallas {

    override method position() {
        return game.at(18, 2)
    }

    override method primerEnemigoAEvaluar() {
        return "                  Comandante: "
    }

    override method defensaPrimerEnemigo() {
        return 5
    }

    override method segundoEnemigoAEvaluar() {
        return "        Soldado: "
    }

    override method defensaSegundoEnemigo() {
        return 4
    }

}

object probabilidadesArqMag inherits ProbabilidadesBatallas {

    override method position() {
        return game.at(18, 1)
    }
    
    override method primerEnemigoAEvaluar() {
        return "              Mago: "
    }

    override method defensaPrimerEnemigo() {
        return 2
    }

    override method segundoEnemigoAEvaluar() {
        return "               Arquero: "
    }

    override method defensaSegundoEnemigo() {
        return 2
    }

}