import cabezal.*
import wollok.game.*
import map.*
import direcciones.*
import edificios.*
import objetos.*

class Personaje {
    //stats
    const property ataqueBase
    const property defensaBase
    const property valor 

    var property team

    var property position = game.at(0,0) //me pedia inicializarlo, pero spawnean en el castillo.


    method image() {
        return self.imageString() + team.estado() + ".png"
    }

    method imageString()

    method enemigosAlAlcance() {
        return self.enemigosAlAlcance(direcciones.principales(), 1)

    }

    method enemigosAlAlcance(direcciones, rango) {
        return direcciones.flatMap({direccion => self.definirEnemigoEn(direccion.siguiente(self.position(), rango))})

    }

    method hayEnemigosAlAlcance() {
        return not self.enemigosAlAlcance().isEmpty()
    }

    method definirEnemigoEn(posicion){
        return mapa.enemigos().filter({enemigo => enemigo.position() == posicion})
    }


    method mover(posicion) {
        self.validarMoverPersonaje(posicion)
        position = posicion
        cabezal.efectoMover()
        self.recogerObjeto(posicion)
        self.pasaAlSiguienteNivelSiSePuede(posicion)
    }

    method validarMoverPersonaje(posicion) {
        mapa.validarSiHayAlgunPersonaje(posicion)
        mapa.validarMoverACastilloEnemigo(posicion)
    }

    method pasaAlSiguienteNivelSiSePuede(posicion) {
        if (mapa.estaElCastilloEnemigoAca(posicion)) {
            mapa.siguienteNivel()  
        }
    }

    method recogerObjeto(posicion) {
        if(mapa.hayObjetoEn(posicion)) {
            if (not self.hayEnemigosAlAlcance()) {
                mapa.objetoEn(posicion).recogerObjeto()
            }
        }
    }


    

    method atacar(enemigo) {
        self.validarSiPuedeAtacar(enemigo)
        self.batalla(enemigo)
        cabezal.efectoAtacar()
        self.playAtaque()
    }
    
    method validarSiPuedeAtacar(enemigo) {
        self.validarSiHayEnemigosAlAlcance()
        self.validarSiEsUnEnemigoAlAlcance(enemigo)
    }

    method validarSiHayEnemigosAlAlcance() {
        return if (not self.hayEnemigosAlAlcance()) {
            self.error("No tengo enemigos al alcance para atacar!")
        }
    }

    method validarSiEsUnEnemigoAlAlcance(enemigo) {
        return if (not self.esUnEnemigoAlAlcance(enemigo)) {
            self.error("El enemigo que intentas atacar no esta a tu alcance!")
        }
    }

    method esUnEnemigoAlAlcance(enemigo) {
        return self.enemigosAlAlcance().contains(enemigo)
    }

    method batalla(enemigo) {

        if(self.leGanaAEnemigo(enemigo)) { 
            enemigo.morir()
        } else {
            self.morir()
        }
    }


    method leGanaAEnemigo(enemigo) {

        const numRandom = 0.randomUpTo(1)

        return numRandom < self.probabilidadDeBatalla(enemigo) 
    }

    method probabilidadDeBatalla(enemigo) {
        return if (self.enemigoEstaARangoDos(enemigo) && not enemigo.esUnEnemigoAlAlcance(self)) {
            self.probabilidad(enemigo) + 0.12
        } else {
            self.probabilidad(enemigo)
        }
    }

    method enemigoEstaARangoDos(enemigo) {
        return self.enemigosAlAlcance(direcciones.principales(), 2).contains(enemigo)
    }

    method probabilidad(enemigo) {
        return self.ataqueBase() / (self.ataqueBase() + enemigo.defensaBase())
    }


    

    method morir() {
        mapa.quitar(self)
        game.removeVisual(self)
    }
    

    method condicionParaSpawn() {
        return true // Lo establezco como true y en las clases que si tienen una condicion para el spawn les hago un override.
    }

    method efectoEnRecursosPorCondicion() {} // No hace nada por default

    method inicializarEnNivel() {
        position = randomizerLimitado.emptyPosition()
        game.addVisual(self)
    }


    method playSpawn() {
        game.sound(self.spawnSound()).play()
    }

    method spawnSound()

    method playAtaque() {
        game.sound(self.ataqueSound()).play()
    }

    method ataqueSound()
}

class Comandante inherits Personaje(ataqueBase = 7, defensaBase = 5, valor = 20) {


    override method imageString() {
        return "com-"
    }

    override method spawnSound() {
        return "spawnCom.mp3"
    }


    override method ataqueSound() {
        return "hitCom.wav"
    }
}


class Mago inherits Personaje(ataqueBase = 5, defensaBase = 2, valor = 11) {


    override method imageString() {
        return "mg-"
    }
  

    override method spawnSound() {
        return "spawnMag.mp3"
    }


    override method ataqueSound() {
        return "hitMago.wav"
    }
}


class Soldado inherits Personaje(ataqueBase = 6, defensaBase = 4, valor = 15) {

    override method imageString() {
        return "so-"
    }


    override method spawnSound() {
        return "spawnSol.mp3"
    }


    override method ataqueSound() {
        return "hitEspada.wav"
    }
}

class Arquero inherits Personaje (ataqueBase = 4, defensaBase = 2, valor = 11) {
    
    override method imageString() {
        return "ar-"
    }

    override method enemigosAlAlcance(){
        return self.enemigosAlAlcance(direcciones.principales(), 2) + self.enemigosAlAlcance(direcciones.todas(), 1)
    }

    override method spawnSound() {
        return "spawnArq.mp3"
    }


    override method ataqueSound() {
        return "hitFlecha.wav"
    }
}

class Golem inherits Personaje(ataqueBase = 4, defensaBase = 10, valor = 35) {
    
    override method imageString() {
        return "go-"
    }

    override method condicionParaSpawn() {
        return castillo.piedrasEnReserva() >= 3
    }

    override method efectoEnRecursosPorCondicion() {
        castillo.piedrasEnReserva(castillo.piedrasEnReserva() - 3)
    }

    override method spawnSound() {
        return "spawnGol.mp3"
    }

    override method ataqueSound() {
        return "hitGolem.wav"
    }

}

class Dragon inherits Personaje (ataqueBase = 9, defensaBase = 4, valor = 35) {

    override method imageString() {
        return "dr-"
    }

    override method condicionParaSpawn() {
        return castillo.huevosEnReserva() >= 1
    }

    override method efectoEnRecursosPorCondicion() {
        castillo.huevosEnReserva(castillo.huevosEnReserva() - 1)
    }

    override method spawnSound() {
        return "spawnDrag.mp3"
    }

    override method ataqueSound() {
        return "hitDragon.wav"
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
