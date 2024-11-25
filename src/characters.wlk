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
        return mapa.enemigos().filter({enemigo => enemigo.position()== posicion})
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
            self.validarSiPuedeRecogerObjeto()
            mapa.objetoEn(posicion).recogerObjeto()
        }
    }

    method validarSiPuedeRecogerObjeto() {
        return if (self.hayEnemigosAlAlcance()) {
            self.error("Primero derrota a los enemigos cercanos a tu alcance, sino no puedo recoger el objeto!")
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
        cabezal.modoCabezal(cabezalNormal)
    }
    

    method condicionParaSpawn() {
        return true // Lo establezco como true y en las clases que si tienen una condicion para el spawn les hago un override.
    }

    method efectosEnRecursosSpawn() {
        castillo.oroEnReserva(castillo.oroEnReserva() - self.valor())
    }

    method inicializarEnNivel() {
        position = randomizerLimitado.emptyPosition()
        game.addVisual(self)
    }


    method playSpawn()

    method playAtaque()
}

class Comandante inherits Personaje(ataqueBase = 7, defensaBase = 5, valor = 20) {

    const property inventario = #{}


    method image(){
        return "com-" + team.estado() + ".png"
    }

    override method playSpawn(){
        game.sound("spawnCom.mp3").play()
    }

    override method playAtaque() {
        game.sound("hitCom.wav").play()
    }
}


class Mago inherits Personaje(ataqueBase = 5, defensaBase = 2, valor = 11) {


    method image() {
        return "mg-" + team.estado()+".png"
    }
  
    override method playSpawn(){
        game.sound("spawnMag.mp3").play()
    }

    override method playAtaque() {
        game.sound("hitMago.wav").play()
    }
}


class Soldado inherits Personaje(ataqueBase = 6, defensaBase = 4, valor = 15) {

    method image(){
        return "so-" + team.estado() +".png"
    }

    override method playSpawn(){
        game.sound("spawnSol.mp3").play()
    }

    override method playAtaque() {
        game.sound("hitEspada.wav").play()
    }
}

class Arquero inherits Personaje (ataqueBase = 4, defensaBase = 2, valor = 11) {
    
    method image(){
        return "ar-" + team.estado() +".png"
    }

    override method enemigosAlAlcance(){
        return self.enemigosAlAlcance(direcciones.principales(), 2) + self.enemigosAlAlcance(direcciones.todas(), 1)
    }

    override method playSpawn(){
        game.sound("spawnArq.mp3").play()
    }

    override method playAtaque() {
        game.sound("hitFlecha.wav").play()
    }
}

class Golem inherits Personaje(ataqueBase = 4, defensaBase = 10, valor = 35) {
    
    method image(){
        return "go-" + team.estado() + ".png"
    }

    override method condicionParaSpawn() {
        return castillo.piedrasEnReserva() >= 3
    }

    override method efectosEnRecursosSpawn() {
        super()
        castillo.piedrasEnReserva(castillo.piedrasEnReserva() - 3)
    }

    override method playSpawn(){
        game.sound("spawnGol.mp3").play()
    }

    override method playAtaque() {
        game.sound("hitGolem.wav").play()
    }

}

class Dragon inherits Personaje (ataqueBase = 9, defensaBase = 4, valor = 30) {

    method image(){
        return "dr-"+ team.estado() + ".png"
    }

    override method condicionParaSpawn() {
        return castillo.huevosEnReserva() >= 1
    }

    override method efectosEnRecursosSpawn() {
        super()
        castillo.huevosEnReserva(castillo.huevosEnReserva() - 1)
    }

    override method playSpawn(){
        game.sound("spawnDrag.mp3").play()
    }

    override method playAtaque() {
        const sonido = game.sound("hitDragon.wav")
        sonido.play()
        sonido.volume(0.4)
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
