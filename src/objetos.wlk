import wollok.game.*
import direcciones.*
import map.*
import characters.*
import edificios.*
import animaciones.*

class Objeto {
    const property position

    method image()

    method solido() {
        return false
    }
}
class ObjetoRecogible inherits Objeto {

    method cantidad() {
        return 1
    }

    method recogerObjeto() {
        game.removeVisual(self)
        mapa.eliminarObjeto(self)
    }

}

class Oro inherits ObjetoRecogible {

    override method image() {
        return "pepitaDeOro.png"
    } 

    override method cantidad() {
        return 20
    }
  
    override method recogerObjeto() {
        castillo.guardarOro(self.cantidad())
        super()
    }

} 

class Piedra inherits ObjetoRecogible {

    override method image() {
        return "pi.png"
    } 
  
    override method recogerObjeto() {
        castillo.guardarPiedra(self.cantidad())
        super()
    }

}

class Huevo inherits ObjetoRecogible {
    override method image() {
        return "huevo.png"
    } 
  
    override method recogerObjeto() {
        castillo.guardarHuevo(self.cantidad())
        super()
    }

}


class Constructor {
    method construir(posicion)

    method instanciar(cantidad) {
        if (cantidad > 0) {
            self.instanciarObjeto(cantidad)
        }
    }

    method instanciarObjeto(cantidad) {
        const objeto = self.construir(randomizer.emptyPosition())
        game.addVisual(objeto)
        mapa.agregarObjeto(objeto)
        self.instanciar(cantidad - 1)
    }
}
object constructorOros inherits Constructor {

    override method construir(posicion) {
        return new Oro(position = posicion)
    }

}

object constructorPiedras inherits Constructor {

    override method construir(posicion) {
        return new Piedra(position = posicion)
    }

}

class Muro inherits Objeto {

    override method image() {
        return "muronew.png"
    }

    override method solido() {
		return true
	}

}


object castilloEnemigo {

    var property position = game.center()

    method image() {
        return "castilloenem.png"
    }

    method solido() {
        return false
    }
}

class Animado inherits Objeto {

    override method image() {
        return animacion.frame().toString() + self.imageString()
    }

    method imageString()
    
}


class CasaMedieval inherits Animado {

    override method imageString() {
        return "casa.png"
    }

    override method solido() {
		return true
	}

}


class Pastito inherits Animado {
    
    override method imageString() {
      return "pastitouo.png"
    }

}

