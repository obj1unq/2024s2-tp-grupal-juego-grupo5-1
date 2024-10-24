import cabezal.*
import wollok.game.*
import map.*
import direcciones.*

class Personaje {
    //stats
    const property ataqueBase
    const property defensaBase
    const property vidaBase
    var property vidaActual = vidaBase

    var property team

    var property position = game.at(0,0) //me pedia inicializarlo, pero spawnean en el castillo.


    var property fueMovido = false
    var property atacoEsteTurno = false

    method efectoMover() {
        fueMovido = true
    }
    

    method efectoAtacar(){
        atacoEsteTurno = true
        cabezal.setModo(cabezalBatalla)
    }


    method enemigosAlAlcance() {
        return self.enemigosAlAlcance(direcciones.principales(), 1)

    }

    method enemigosAlAlcance(direcciones, rango) {
        return direcciones.flatMap({direccion => self.definirEnemigoEn(direccion.siguiente(self.position(), rango))})

    }

    method definirEnemigoEn(posicion){
        return mapa.enemigos().filter({enemigo => enemigo.position()== posicion})
    }


    method mover(posicion) {
        position = posicion
        self.efectoMover()
    }

    
    method verificarMovimiento() {
        if (fueMovido) {
            self.error("Ya me movi este turno")
        }
    }

    method recargarMovimiento() {
      fueMovido = false
    }

    method recargarAtaque(){
        atacoEsteTurno = false
    }

    method atacar(enemigo) {
        self.validarAtaque()
        enemigo.recibirDano()
        enemigo.morirSiCorresponde()
        // self.efectoAtacar()
    }

    method validarAtaque(){
        if (atacoEsteTurno){
            self.error("Ya ataque este turno")
        }
    }

    method recibirDano() {
        vidaActual -= (cabezal.seleccionActualAliada().ataqueBase() - cabezal.seleccionActualEnemiga().defensaBase())
    }
    method morirSiCorresponde() {
        if (vidaActual < 1){
            self.morir()
        }
    }
    method morir() {
        mapa.quitarEnemigo(self)
        game.removeVisual(self)
        cabezal.modoCabezal(cabezalNormal)
    }
    


}

class Comandante inherits Personaje(ataqueBase = 7, defensaBase = 2, vidaBase = 100) {

    const property inventario = #{}


    method image(){
        return "comandante-" + team.estado() + ".png"
    }

}


class Mago inherits Personaje(ataqueBase = 2, defensaBase = 1, vidaBase = 100) {


    method image() {
        return "mage-" + team.estado()+".png"
    }
  
}


class Soldado inherits Personaje(ataqueBase = 4, defensaBase = 2, vidaBase = 100) {

    method image(){
        return "soldado-" + team.estado() +".png"
    }
}

class Arquero inherits Personaje (ataqueBase = 5, defensaBase = 1, vidaBase = 100) {
    
    method image(){
        return "arquero-" + team.estado() +".png"
    }

    override method enemigosAlAlcance(){
        return self.enemigosAlAlcance(direcciones.principales(), 2) + self.enemigosAlAlcance(direcciones.todas(), 1)


    }


}

class Golem inherits Personaje(ataqueBase = 5, defensaBase = 5, vidaBase = 100) {
    
    method image(){
        return "golem-" + team.estado() + ".png"
    }
}

class Dragon inherits Personaje (ataqueBase = 10, defensaBase = 3, vidaBase = 100) {

    method image(){
        return "dragon-"+ team.estado() + ".png"
    }
}

object aliado {
    method estado(){
        return "aliado"
    }
}

object enemigo {
    method estado(){
        return "enemigo"
    }
}
