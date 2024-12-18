import map.*
import objetos.*
import edificios.*
import wollok.game.*
import hud.*
import cabezal.*
import characters.*
import pantallas.*

class Nivel {

    var property turnosDelNivel


    method tableroNivel() {
        return mapa.nivelActual().tablero()
    }

    method inicializar() {
        self.dibujar()
        constructorOros.instanciar(2)
	    constructorPiedras.instanciar(1)
        castillo.inicializar()
        castilloEnemigo.inicializar()
        cabezal.inicializar()
        mapa.inicializarAliadosVivos()
        hud.inicializar()
    }


    method dibujar() {
        game.height(self.tableroNivel().size())
        game.width(self.tableroNivel().get(0).size())

        (0..game.width() - 1).forEach({ x =>
            (0..game.height() -1).forEach({y =>
            self.tableroNivel().get(y).get(x).dibujarEn(game.at(x,y))
            })
        })
    }

    method siguiente() {
        mapa.nivelActual(self.nivelSiguiente())
    }

    method nivelSiguiente() {
        return
    }

    method limpiarTablero() {
        mapa.removerTodasLasVisuales()
        self.tableroNivel().clear()
    }



    method gastarTurno() {
        turnosDelNivel -= 1
    }

    method noHayMasTurnos() {
        return turnosDelNivel == 0
    }

    method enter() {
    } // Por default no hace nada

}


object pantallaInicio inherits Nivel(turnosDelNivel = 1) {
    const property tablero = 
    [[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],    
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],    
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],   
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],  
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], 
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [in,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]
     ].reverse()

    

    override method inicializar() {
        self.ejecutarPantalla()
    }

    method ejecutarPantalla() {
        self.dibujar()
        keyboard.enter().onPressDo({mapa.enter()})
    }

    override method enter() {
        self.siguiente()
        mapa.inicioJuego()
    }


    override method nivelSiguiente() {
        return nivel1
    }
}
object nivel1 inherits Nivel(turnosDelNivel = 15) {
    const property tablero = 
    [[_,_,c,_,_,_,_,_,_,_,_,_,_,pa,_,_,_,_,_,_,_,_,_],
     [_,pa,_,_,_,_,_,pa,_,_,_,_,ae,_,coe,_,_,_,_,_,_,_,_],    
     [_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],    
     [_,_,_,_,_,_,_,_,_,_,_,_,pa,_,_,_,_,_,_,_,_,_,_],   
     [_,_,pa,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],  
     [_,_,_,_,_,_,_,_,o,m,m,m,m,m,m,_,_,_,_,_,_,_,_], 
     [_,_,c,_,_,_,m,m,se,m,_,_,_,_,_,_,_,_,_,_,_,_,_], 
     [m,m,m,m,m,m,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [me,o,ae,_,_,_,_,_,_,_,pa,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,pa,_,_,_,_,_,_,c,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,o,_,_,_,_,_,_,_,_,_,_,_,_,_]
     ].reverse()

    override method nivelSiguiente() {
        return nivel2
    }

}

object nivel2 inherits Nivel(turnosDelNivel = 25) {

    const property tablero = 
    [[_,_,_,m,_,_,_,_,_,pa,_,_,_,me,_,_,_,_,_,_,_,_,_],
     [_,o,_,m,_,_,_,c,_,_,_,_,_,coe,_,_,_,_,_,_,_,_,_],    
     [_,p,_,se,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],    
     [_,p,_,ae,_,_,_,c,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],   
     [m,m,m,m,_,_,_,_,_,_,_,_,_,_,c,_,_,_,_,_,_,_,_],  
     [_,pa,pa,_,_,_,_,_,pa,_,_,_,_,_,_,_,_,_,_,_,_,_,_], 
     [_,_,_,_,_,_,_,m,m,m,_,_,_,_,_,_,_,_,_,_,_,_,_], 
     [_,o,_,_,_,_,_,_,_,_,_,_,_,m,m,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,pa,_,_,m,h,_,_,_,_,_,_,_,_],
     [_,_,_,o,_,coe,_,o,_,_,_,_,_,m,ge,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,c,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,pa,_,_,pa,_,_,_,_,_,_,_,_,_,_,_]
     ].reverse()

    override method nivelSiguiente() {
        return nivel3
    }

}

object nivel3 inherits Nivel(turnosDelNivel = 32) {

    const property tablero = 
    [[_,_,p,_,m,_,_,_,pa,_,_,_,_,ge,_,_,_,_,_,_,_,_,_],
     [_,o,se,_,se,_,_,_,o,_,_,_,_,de,ae,_,_,_,_,_,_,_,_],    
     [_,_,p,_,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],    
     [m,m,m,m,m,_,_,_,_,pa,_,_,_,_,_,_,_,_,_,_,_,_,_],   
     [_,_,_,_,_,_,_,_,_,_,_,_,m,m,m,_,_,_,_,_,_,_,_],  
     [ae,c,_,_,_,_,_,_,_,_,_,_,o,ae,_,_,_,_,_,_,_,_,_], 
     [h,me,_,_,_,_,_,_,m,m,m,m,_,_,_,_,_,_,_,_,_,_,_], 
     [ae,c,_,_,o,me,_,_,_,pa,pa,_,_,_,c,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,o,_,_,_,_,c,_,_,_,_,_,_,_,_],
     [m,m,m,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,m,_,_,_,_,_,_,_,o,_,_,pa,_,_,_,_,_,_,_,_],
     [_,_,_,coe,_,_,_,_,pa,_,_,_,_,_,_,_,_,_,_,_,_,_,_]
     ].reverse()

    override method nivelSiguiente() {
        return pantallaFinal
    }
}

object pantallaFinal inherits Nivel (turnosDelNivel = 1) {
    const property tablero = 
    [[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],    
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],    
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],   
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],  
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], 
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
     [fv,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]
     ].reverse()

    override method inicializar() {
        self.ejecutarFin()
    }

    method ejecutarFin() {
        self.dibujar()
        game.stop()
    }
}


object _ {
    method dibujarEn(position) {
    }
    
}


object m {
    method dibujarEn(position) {
        const muro = new Muro(position = position)
        game.addVisual(muro)
        mapa.agregarObjeto(muro)
    }
}

object c {
    method dibujarEn(position) {
        const casa = new CasaMedieval(position = position)
        game.addVisual(casa)
        mapa.agregarObjeto(casa)
    }
}


object h {
    method dibujarEn(position) {
        const huevo = new Huevo(position = position)
        game.addVisual(huevo)
        mapa.agregarObjeto(huevo)
    }
}

object p {
    method dibujarEn(position) {
        const piedra = new Piedra(position = position)
        game.addVisual(piedra)
        mapa.agregarObjeto(piedra)
    }
}

object o {
    method dibujarEn(position) {
        const oro = new Oro(position = position)
        game.addVisual(oro)
        mapa.agregarObjeto(oro)
    }
}

object coe {
    method dibujarEn(position) {
        const comandanteEnemigo = new Comandante(team = enemigo, position = position)
        game.addVisual(comandanteEnemigo)
        mapa.agregarEnemigo(comandanteEnemigo)
    }
}

object me {
    method dibujarEn(position) {
        const magoEnemigo = new Mago(team = enemigo, position = position)
        game.addVisual(magoEnemigo)
        mapa.agregarEnemigo(magoEnemigo)
    }
}

object se {
    method dibujarEn(position) {
        const soldadoEnemigo = new Soldado(team = enemigo, position = position)
        game.addVisual(soldadoEnemigo)
        mapa.agregarEnemigo(soldadoEnemigo)
    }
}

object ae {
    method dibujarEn(position) {
        const arqueroEnemigo = new Arquero(team = enemigo, position = position)
        game.addVisual(arqueroEnemigo)
        mapa.agregarEnemigo(arqueroEnemigo)
    }
}

object ge {
    method dibujarEn(position) {
        const golemEnemigo = new Golem(team = enemigo, position = position)
        game.addVisual(golemEnemigo)
        mapa.agregarEnemigo(golemEnemigo)
    }
}

object de {
    method dibujarEn(position) {
        const dragonEnemigo = new Dragon(team = enemigo, position = position)
        game.addVisual(dragonEnemigo)
        mapa.agregarEnemigo(dragonEnemigo)
    }
}

object in {
    method dibujarEn(position) {
        inicio.position(position)
        game.addVisual(inicio)
    }
}

object fv {
    method dibujarEn(position) {
        finVictoria.position(position)
        game.addVisual(finVictoria)
    }
}

object pa {
    method dibujarEn(position) {
        const pastito = new Pastito(position = position)
        game.addVisual(pastito)
    }
}