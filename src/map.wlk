import cabezal.*
import wollok.game.*
import objetos.*
import characters.*
import edificios.*
import turno.*
import direcciones.*
import pantallas.*
import hud.*
import niveles.*
import animaciones.*


object mapa {
    const property aliados = #{}
    const property enemigos = #{}
    const property objetos = #{}
    var property nivelActual = pantallaInicio 

    method inicioJuego() {
        self.removerTodasLasVisuales()
        self.iniciarControles()
        self.iniciarMusica()
        self.iniciarAnimaciones()
        nivelActual.inicializar()
        
    }

    method enter() {
        nivelActual.enter()
    }

    method removerTodasLasVisuales() {
        game.allVisuals().forEach({v => game.removeVisual(v)})
    }

    method iniciarControles() {
    keyboard.left().onPressDo({cabezal.mover(izquierda)})
    keyboard.right().onPressDo({cabezal.mover(derecha)})
    keyboard.up().onPressDo({cabezal.mover(arriba)})
    keyboard.down().onPressDo({cabezal.mover(abajo)})
	keyboard.num1().onPressDo({castillo.spawn(new Comandante(team = aliado))})
	keyboard.num2().onPressDo({castillo.spawn(new Soldado (team=aliado))})
	keyboard.num3().onPressDo({castillo.spawn(new Arquero(team = aliado))})
	keyboard.num4().onPressDo({castillo.spawn(new Mago (team = aliado))})
	keyboard.num5().onPressDo({castillo.spawn(new Golem (team= aliado))})
	keyboard.num6().onPressDo({castillo.spawn(new Dragon (team = aliado))})
	keyboard.a().onPressDo({cabezal.accionar()})
	keyboard.s().onPressDo({cabezal.cancelar()})
	keyboard.t().onPressDo({turno.pasarABatalla()})
	keyboard.r().onPressDo({turno.terminarTurno()})
    }

    method iniciarMusica() {
        const music = game.sound("background3.mp3")
 	    music.shouldLoop(true)
	    music.volume(0.04)
	    game.schedule(500, { music.play()} )
    }

    method iniciarAnimaciones() {
        game.onTick(500, "animacion", {animacion.sumarFrame()})
    }

    method validarSiEstaDentro(posicion) {
        return if (not self.estaDentro(posicion)) {
             cabezal.error("No me puedo mover a esa posición ya que esta fuera de los limites!")
        }
    }

    method estaDentro(posicion) {
		return posicion.x().between(0, game.width() - 9) and posicion.y().between(0, game.height() - 1)
	}

    method validarSiHayObjetoSolido(posicion) {
        return if (self.hayObjetoSolido(posicion)) {
            cabezal.error("No me puedo mover a esa posición ya que hay un objeto solido")
        }
    }

    method hayObjetoSolido(posicion) {
        return self.hayObjetoEn(posicion) && self.objetoEn(posicion).solido()
    }

    method validarSiHayAlgunPersonaje(posicion) {
        return if (self.hayUnidadAca(posicion)) {
            cabezal.error("No puedo mover la seleccion actual a esa posición ya que hay otro personaje")
        }
    }

    method validarMoverACastilloEnemigo(posicion) {
        return if (self.estaElCastilloEnemigoAca(posicion) && not self.todosLosEnemigosEstanVencidos()) {
            cabezal.error("¡No podes tomar el castillo enemigo hasta derrotar a todos los enemigos!")
        }
    }

    method estaElCastilloEnemigoAca(posicion) {
        return castilloEnemigo.position() == posicion
    }

    method todosLosEnemigosEstanVencidos() {
        return enemigos.isEmpty()
    }

    method quitar(personaje) {
        if (self.esUnEnemigo(personaje)) {
            enemigos.remove(personaje)
        } else {
            aliados.remove(personaje)
        }
    }

    method esUnEnemigo(personaje) {
        return enemigos.contains(personaje)
    }

    method agregarAliado(aliado){
     aliados.add(aliado)
    }

    method agregarEnemigo(enemigo){
        enemigos.add(enemigo)
    }

    method aliadosEn(posicion) {
        return aliados.find({pj => pj.position() == posicion})
    }

    method enemigosEn(posicion) {
        return enemigos.find({pj => pj.position() == posicion})
    }

    method validarSeleccionAliada(posicion) {
        if (not self.hayAliadosEn(posicion)){
            cabezal.error("No hay nada para seleccionar!")
        }
    }

    method hayAliadosEn(posicion) {
        return aliados.any({aliado => aliado.position() == posicion})
    }

    method hayEnemigosEn(posicion){
        return enemigos.any({enemigo => enemigo.position() == posicion})
    }

    method hayUnidadAca(posicion){
        return self.hayAliadosEn(posicion) || self.hayEnemigosEn(posicion)
    }
    method validarSeleccionEnemiga(posicion) {
        if (not self.hayEnemigosEn(posicion)){
            cabezal.error("No hay nada para seleccionar!")
        }
    }

    method agregarObjeto(objeto) {
        objetos.add(objeto)
    }

    method eliminarObjeto(objeto) {
        objetos.remove(objeto)
    } 

    method objetoEn(posicion) {
        return objetos.find({o => o.position() == posicion})
    }

    method hayObjetoEn(posicion) {
        return objetos.any({o => o.position() == posicion})
    }

    method inicializarAliadosVivos() {
        if (not self.todosLosAliadosEstanVencidos()) {
            aliados.forEach({a => a.inicializarEnNivel()})
        }
    }

    method todosLosAliadosEstanVencidos() {
        return aliados.isEmpty()
    }

    method siguienteNivel() {
        objetos.clear()
        nivelActual.limpiarTablero()
        nivelActual.siguiente()
        nivelActual.inicializar()
    }


    method terminarJuego() {
        self.terminarJuegoPorTurnos()
        self.terminarJuegoPorTropas()
    }

    method terminarJuegoPorTurnos() {
        if (nivelActual.noHayMasTurnos()) {
            game.addVisual(finDerrotaTurnos)
            game.stop()
        }
    }

    method terminarJuegoPorTropas() {
        if (self.noHayTropasNiRecursosParaSpawn()) {
            game.addVisual(finDerrotaTropas)
            game.stop()
        }
    }

    method noHayTropasNiRecursosParaSpawn() {
        return self.todosLosAliadosEstanVencidos() && castillo.oroEnReservaNoEsSuficiente()
    }

}


