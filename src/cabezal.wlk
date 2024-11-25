import characters.*
import wollok.game.*
import direcciones.*
import map.*
import objetos.*
import edificios.*
import turno.*
import textos.*


object cabezal {

  var property seleccionActualAliada = null
  var property position = game.origin()
  var property modoCabezal = cabezalNormal
  var property seleccionActualEnemiga = null
  var property yaMoviEnElTurno = false
  var property atacoEsteTurno = false
  

  method image(){
    return modoCabezal.image()
  }

  method efectoAtacar(){
    atacoEsteTurno = true
    self.setModo(cabezalNormal)
  }

  method recargarAtaque(){
    atacoEsteTurno = false
  }

  method efectoMover() {
    yaMoviEnElTurno = true
  }
  
  method recargarMovimiento() {
    yaMoviEnElTurno = false
  }

  method inicializar() {
    position = game.origin()
    modoCabezal = cabezalNormal
    game.addVisual(self)
    self.recargarMovimiento()
  }

  method mover(direccion) {
    const siguiente = direccion.siguiente(position) 
    self.validarMoverCabezal(siguiente)
    position = siguiente
  }

  method validarMoverCabezal(posicion) {
    mapa.validarSiEstaDentro(posicion)
    mapa.validarSiHayObjetoSolido(posicion)
  }

  method cancelar() {
    modoCabezal = cabezalNormal
    self.limpiarSelecAliada()
    self.limpiarSelecEnemiga()
    pjActual.removerPjActual()
  }

  method accionar() {
    modoCabezal.accionar()
  }

  method limpiarSelecAliada() {
    seleccionActualAliada = null
  }

  method limpiarSelecEnemiga() {
    seleccionActualEnemiga = null
  }

  method setAliado(aliado) {
    seleccionActualAliada = aliado
    self.actualizarHUD()
  }

  method hayAliadoSeleccionado() {
    return seleccionActualAliada != null
  }

  method actualizarHUD() {
    pjActual.removerPjActual()
    self.actualizarImagenEnHUD()
    game.addVisual(pjActual)
  }

  method actualizarImagenEnHUD() {
    if (self.hayAliadoSeleccionado()) {
      pjActual.actualizarImage(seleccionActualAliada.image())
    } else {
      pjActual.actualizarImage(null)
    }
  }


  method setModo(modo) {
    modoCabezal = modo
  }

  method setEnemigo(enemigo) {
    seleccionActualEnemiga = enemigo    
  }

  method obtenerPjAliado() {
    return mapa.aliadosEn(position)
  }

  method obtenerPjEnemigo() {
    return mapa.enemigosEn(position)
  }

  method obtenerObjetoEn() {
    return mapa.objetoEn(position)
  }
  
}

class ModoCabezal {

  method image()

  method accionar()

  
}

object cabezalNormal inherits ModoCabezal {

  override method image() {
    return "cabezal.png"
  }

  //SELECCIONAR
  override method accionar() {
    self.verificarMovimiento()
    mapa.validarSeleccionAliada(cabezal.position())
    cabezal.setAliado(cabezal.obtenerPjAliado())
    cabezal.setModo(cabezalSeleccion)
  }

  method verificarMovimiento() {
    if (cabezal.yaMoviEnElTurno()) {
      cabezal.error("Ya moviste una tropa en este turno!")
      }
    }

}

object cabezalSeleccion inherits ModoCabezal {
  
  override method image() {
    return "cabezal_seleccion.png"
  }

  //MOVER
  override method accionar() {
    cabezal.seleccionActualAliada().mover(cabezal.position())
    cabezal.seleccionActualAliada().enemigosAlAlcance()
    cabezal.limpiarSelecAliada()
    cabezal.setModo(cabezalBatalla)
    pjActual.removerPjActual()
  }

}

object cabezalBatalla inherits ModoCabezal {

  override method image() {
      return "cabezal_batalla.png"
  }

  //SELECCIONAR ENEMIGO
  override method accionar() {
    mapa.validarSeleccionAliada(cabezal.position()) 
    cabezal.setAliado(cabezal.obtenerPjAliado())
    cabezal.setModo(cabezalAtaque)
  }


}

object cabezalAtaque inherits ModoCabezal {
  
  override method image() {
    return "cabezal_ataque.png"
  }

  override method accionar() {
    mapa.validarSeleccionEnemiga(cabezal.position())
    cabezal.setEnemigo(cabezal.obtenerPjEnemigo())
    cabezal.seleccionActualAliada().atacar(cabezal.seleccionActualEnemiga())
    turno.terminarTurno() 
  }

}

