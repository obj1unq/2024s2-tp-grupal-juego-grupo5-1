import wollok.game.*
import textos.*


object hud{
    var property position = null

    
    method image(){
        return "hud6.png"
    }

    method inicializar() {
        position = game.at(15, 0)
        game.addVisual(self)
        self.inicializarTextos()
    }

    method inicializarTextos() {
    game.addVisual(cantidadTurnos)
	game.addVisual(textoReservas)
	game.addVisual(statsPjActual)
	game.addVisual(probabilidades)
	game.addVisual(probabilidadesDragonGolem)
	game.addVisual(probabilidadesComandSol)
	game.addVisual(probabilidadesArqMag)
    }

}