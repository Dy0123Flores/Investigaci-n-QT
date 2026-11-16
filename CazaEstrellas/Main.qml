import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

ApplicationWindow {
    id: ventana
     width: 390
     height: 740
     minimumWidth: 320
     minimumHeight: 550
     visible: true
     title: "Órbita Fugaz"
     color: "#101827"

     property int pantalla: 0
     property string nombreJugador: ""
     property string aliasJugador: ""
     property int edadJugador: 0
     property string dificultad: "Normal"

     property int puntos: 0
     property int tiempo: 30
     property int combo: 0
     property int mejorCombo: 0
     property int estrellas: 0
     property int meteoritos: 0

     property bool jugando: false
     property bool pausado: false
     property bool partidaTerminada: false
     property bool sonidoActivo: true

     property int tipoObjetivo: 0
     property int tamañoObjetivo: 65
     property real posicionX: 0
     property real posicionY: 0
     property string avisoEtapa: ""

     readonly property int etapa: tiempo > 20 ? 1 : tiempo > 10 ? 2 : 3

}
